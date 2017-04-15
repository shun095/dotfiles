# -*- coding:utf-8 -*-
import numpy as np
import copy


def ComputeJacobian(self, finger_num, joint_angle, motoraxis, finlen, fingrad):

    """ joint_angle : 1 * 4 リスト
    """
    d_theta = 0.0001
    Jacobian = np.zeros((3, 4))

    for axis in range(3):  # x,y,z軸
        for joint_num in range(4):  # ジョイントそれぞれ
            # とりあえず４関節コピー
            joint_angle_p_dtheta = copy.deepcopy(joint_angle)
            # 一つの関節だけ＋d_theta
            joint_angle_p_dtheta[joint_num] = \
                joint_angle_p_dtheta[joint_num] + d_theta
            # ひとつだけ＋d_thetaした時のposition変化量
            d_position = \
                self.GetFingertipPosition(
                        joint_angle_p_dtheta, motoraxis, finlen, fingrad) - \
                self.GetFingertipPosition(
                        joint_angle, motoraxis, finlen, fingrad)
            Jacobian[axis][joint_num] = d_position[axis] / d_theta
    print Jacobian


def function():
    """TODO: Docstring for function new.

    :arg1: TODO
    :returns: TODO

    """
    pass
