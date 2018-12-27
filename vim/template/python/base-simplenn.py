#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# {{_expr_:strftime('%Y-%m-%d')}} {{_name_}}.py
# Copyright © {{_expr_:strftime('%Y')}} ishitaku5522
# Distributed under terms of the MIT license.

import os
import numpy as np
import tensorflow as tf
import pandas as pd
import matplotlib.pyplot as plt
import glob

script_dir = os.path.dirname(os.path.realpath(__file__))

FLAGS = tf.app.flags.FLAGS

tf.app.flags.DEFINE_integer(
    'restore_epoch', 0, "Epoch to restore")
tf.app.flags.DEFINE_integer(
    'train_epoch', 0, "Epoch to train")
tf.app.flags.DEFINE_integer(
    'times_to_train', 1, "Try N times loop of training to find the best model")
tf.app.flags.DEFINE_integer(
    'restore_trial', 0, "Trial number to restore")
tf.app.flags.DEFINE_integer(
    'early_stopping_effort', 5, "Threshold epoch for early stopping")
tf.app.flags.DEFINE_string(
    'model_name', 'default', "Folder name of the model to save")
tf.app.flags.DEFINE_boolean(
    'bayesian', False, "Run bayesian optimization if True")
tf.app.flags.DEFINE_boolean(
    'plot', False, "Plot and show graph for each training if True")


def func(x):
    return x * np.sin(x) + x / 2


class NeuralNet(object):
    def forward(self, x, units=None, keep_prob=1.0):

        layer = x
        for i in range(len(units) - 2):
            W = tf.get_variable("W"+str(i),
                                shape=[units[i], units[i + 1]],
                                initializer=tf.contrib.layers.xavier_initializer())
            b = tf.get_variable("b"+str(i), shape=[units[i + 1]],
                                initializer=tf.contrib.layers.xavier_initializer())
            layer = tf.nn.dropout(layer, keep_prob)
            layer = tf.nn.tanh(tf.matmul(layer, W) + b)

        W = tf.get_variable("Wout", shape=[units[-2], units[-1]])
        b = tf.get_variable("bout", shape=[units[-1]])
        layer = (tf.matmul(layer, W) + b)
        return layer

    def loss(self, pred, actual):
        ans = tf.reduce_mean(tf.square(pred - actual))
        return ans


def train(params=None, num_trial=0, return_best_loss=False):
    train_epoch = FLAGS.train_epoch
    restore_epoch = FLAGS.restore_epoch

    if restore_epoch < train_epoch:
        training = True
    else:
        training = False

    # Default parameters
    keep_prob = 1.0
    batch_size = 512
    time_series = 0

    if time_series > 0:
        units = [time_series * 3, 16, 8, 3]
    else:
        units = [1 * 3, 16, 8, 3]

    if params:
        if 'keep_prob' in params:
            keep_prob = params['keep_prob']
        if 'batch_size' in params:
            batch_size = params['batch_size']
        if 'units' in params:
            units = params['units']

    model_name = "./savesdir/{}/".format(FLAGS.model_name)

    for u in units:
        model_name += "{}-".format(u)

    model_name += "/batch{}_kp{:.0e}".format(batch_size, keep_prob)
    if training:
        model_name += "/trial{}".format(num_trial)
    else:
        model_name += "/trial{}".format(FLAGS.restore_trial)

    glob_pattern_train = "./TrainData/*.csv"
    glob_pattern_test = "./TestData/*.csv"
    x_train_regex = ".*"
    y_train_regex = ".*"
    x_test_regex = x_train_regex
    y_test_regex = y_train_regex

    x_max = 100
    x_min = -100
    y_max = 100
    y_min = -100
    scale = 0.8

    print(model_name)
    print("Units      {}".format(units))
    print("Keep prob  {}".format(keep_prob))
    print("Batch size {}".format(batch_size))

    os.makedirs(model_name, exist_ok=True)

    fulldata_train = glob.glob(glob_pattern_train)
    fulldata_test = glob.glob(glob_pattern_test)

    csvs_df_train = []
    for data in fulldata_train:
        csvs_df_train.append(pd.read_csv(data))

    csvs_df_test = []
    for data in fulldata_test:
        csvs_df_test.append(pd.read_csv(data))

    csv_x_train = []
    csv_y_train = []
    for csv_df in csvs_df_train:
        csv_x_train.append(
                csv_df.filter(regex=x_train_regex).values)
        csv_y_train.append(
                csv_df.filter(regex=y_train_regex).values)

    csv_x_test = []
    csv_y_test = []
    for csv_df in csvs_df_test:
        csv_x_test.append(
                csv_df.filter(regex=x_test_regex).values)
        csv_y_test.append(
                csv_df.filter(regex=y_test_regex).values)

    x_train = np.concatenate(csv_x_train, axis=0)
    y_train = np.concatenate(csv_y_train, axis=0)
    x_test = np.concatenate(csv_x_test, axis=0)
    y_test = np.concatenate(csv_y_test, axis=0)

    if time_series > 0:
        tmp = []
        for i in range(len(x_train) - time_series):
            tmp.append(x_train[i: i + time_series])

        x_train = np.reshape(np.array(tmp), [len(tmp), -1])
        y_train = y_train[time_series:]

        tmp = []
        for i in range(len(x_test) - time_series):
            tmp.append(x_test[i: i + time_series])

        x_test = np.reshape(np.array(tmp), [len(tmp), -1])
        y_test = y_test[time_series:]

    x_train = scale * 2 / (x_max - x_min) * (x_train - (x_max + x_min) / 2)
    y_train = scale * 2 / (y_max - y_min) * (y_train - (y_max + y_min) / 2)
    x_test = scale * 2 / (x_max - x_min) * (x_test - (x_max + x_min) / 2)
    y_test = scale * 2 / (y_max - y_min) * (y_test - (y_max + y_min) / 2)

    tf.reset_default_graph()

    X = tf.placeholder(tf.float32, shape=[None, x_train.shape[-1]])
    Y = tf.placeholder(tf.float32, shape=[None, y_train.shape[-1]])

    dataset = tf.data.Dataset.from_tensor_slices((X, Y))
    dataset = dataset.shuffle(buffer_size=10000)
    dataset = dataset.batch(batch_size)
    dataset = dataset.prefetch(batch_size)

    iterator = dataset.make_initializable_iterator()
    next_element = iterator.get_next()

    feed_dict_train = {
        X: x_train,
        Y: y_train,
    }

    feed_dict_test = {
        X: x_test,
        Y: y_test,
    }

    model = NeuralNet()

    if training:
        pred_op_batch = model.forward(next_element[0],
                                      units=units,
                                      keep_prob=keep_prob)
    else:
        pred_op_batch = model.forward(next_element[0],
                                      units=units)
    loss_op_batch = model.loss(pred_op_batch, next_element[1])
    optimizer = tf.train.AdamOptimizer()
    train_op = optimizer.minimize(loss_op_batch)

    with tf.variable_scope('', reuse=True):
        pred_op = model.forward(X, units=units)
        loss_op = model.loss(pred_op, Y)

    tf.add_to_collection("X", X)
    tf.add_to_collection("Y", Y)
    tf.add_to_collection("pred_op", pred_op)
    tf.add_to_collection("loss_op", loss_op)

    saver = tf.train.Saver(max_to_keep=10)
    best_saver = tf.train.Saver(max_to_keep=1)

    config = tf.ConfigProto()
    config.gpu_options.allow_growth = True
    #  config = tf.ConfigProto(
    #      gpu_options=tf.GPUOptions(
    #          visible_device_list="0"
    #      )
    #  )

    with tf.Session(config=config) as sess:
        sess.run(tf.global_variables_initializer())

        if not training:
            print("Restoring {}"
                  .format('./'+model_name+'/step-'+str(restore_epoch)))
            saver.restore(sess, './'+model_name+'/step-'+str(restore_epoch))

        early_stop_cnt = 0
        best_loss = 10000
        best_epoch = 0

        for epoch in range(restore_epoch + 1, train_epoch + 1):

            sess.run(iterator.initializer, feed_dict=feed_dict_train)

            while True:
                try:
                    sess.run(train_op)
                except tf.errors.OutOfRangeError:
                    break

            if epoch % 100 == 0:
                loss = sess.run(loss_op, feed_dict=feed_dict_train)
                loss_test = sess.run(loss_op, feed_dict=feed_dict_test)

                if loss_test > best_loss:
                    early_stop_cnt += 1
                else:
                    best_loss = loss_test
                    best_epoch = epoch
                    best_saver.save(
                        sess,
                        './'+model_name+'/best_step',
                        global_step=epoch)
                    early_stop_cnt = 0

                saver.save(sess, './'+model_name+'/step', global_step=epoch)
                print("epoch {}: {:.5e} {:.5e}".format(epoch, loss, loss_test))

                if early_stop_cnt >= 5:
                    print("Best loss: {} at {}".format(best_loss, best_epoch))
                    break

            if epoch == restore_epoch + 1:
                print("Train started!")

        if training:
            saver.save(sess, './'+model_name+'/step', global_step=epoch)

        pred = sess.run(pred_op, feed_dict=feed_dict_train)
        pred_test = sess.run(pred_op, feed_dict=feed_dict_test)

    if FLAGS.plot:
        plt.figure("input")
        plt.title(model_name)
        plt.plot(x_train,    color="g")

        plt.figure("train")
        plt.title(model_name)
        plt.ylim((-1, 1))
        plt.plot(y_train,    color="b")
        plt.plot(pred, color="r")

        plt.figure("test")
        plt.title(model_name)
        plt.ylim((-1, 1))
        plt.plot(y_test,    color="b")
        plt.plot(pred_test, color="r")
        plt.show()

    if return_best_loss:
        return best_loss


def f(inp):
    x = inp
    x = int(inp[:, 0])
    y = int(inp[:, 1])

    units = [3] + [x for i in range(y)] + [3]

    best_loss = 10000
    for i in range(5):
        params = {
            'units': units,
        }
        loss = train(params=params, num_trial=i, return_best_loss=True)
        if loss < best_loss:
            best_loss = loss
    print("Best loss for bayes {}".format(best_loss))
    return loss


def bayesian():
    import GPyOpt
    import pickle

    bounds = [
        {'name': 'x',
            'type': 'discrete',
            'domain': tuple(range(1, 11, 1))},
        {'name': 'y',
            'type': 'discrete',
            'domain': tuple(range(1, 11, 1))}
    ]

    save_path = "bayes/sample"

    os.makedirs(os.path.dirname(save_path), exist_ok=True)

    bayesian_opt = GPyOpt.methods.BayesianOptimization(
        f=f,
        domain=bounds,
        initial_design_numdata=5,
        acquisition_type='LCB',
        verbosity=True)
    bayesian_opt.run_optimization(max_iter=30)

    print("Baysian file name: {}".format(save_path))
    print("Bayesian optimized parameters: {}"
          .format(bayesian_opt.x_opt))
    print("Bayesian optimized loss: {}"
          .format(bayesian_opt.fx_opt))
    print("Bayesian X:\n{}".format(bayesian_opt.X))
    print("Bayesian Y:\n{}".format(bayesian_opt.Y))

    plt.scatter(bayesian_opt.X[:, 0],
                bayesian_opt.X[:, 1],
                c=bayesian_opt.Y[:, 0])

    plt.savefig("{}.png".format(save_path))
    with open("{}.pickle".format(save_path), "wb") as pfile:
        pickle.dump(bayesian_opt, pfile)


def main(argv):
    if FLAGS.bayesian:
        bayesian()

    else:
        best_loss = 10000
        best_i = 0
        for i in range(FLAGS.times_to_train):
            loss = train(num_trial=i, return_best_loss=True)
            if loss < best_loss:
                best_loss = loss
                best_i = i
            print("Current best loss: {:.5e} at tr{}"
                  .format(best_loss, best_i))
        print("Final best loss: {:.5e} at tr{}".format(best_loss, best_i))


if __name__ == '__main__':
    tf.app.run(main)
