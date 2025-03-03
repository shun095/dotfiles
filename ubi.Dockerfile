FROM registry.access.redhat.com/ubi9/ubi:latest

ARG TERM
ENV TERM=${TERM}

RUN dnf -y install glibc-langpack-ja && \
    dnf -y install ncurses util-linux-user sudo && \
    echo "%wheel         ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    useradd shun095 && \
    usermod -aG wheel shun095 && \
    dnf clean all

USER shun095
WORKDIR /home/shun095
COPY --chown=shun095:shun095 . /home/shun095/dotfiles

# RUN export TERM=${TERM} && \
#     $HOME/dotfiles/install-invoke.sh && \
#     chsh -s /bin/zsh


# localedef -i ja_JP -f UTF-8 ja_JP.UTF-8 && \
# ENV LANG ja_JP.UTF-8
# ENV LANGUAGE ja_JP:ja
# ENV LC_ALL ja_JP.UTF-8

CMD ["/bin/zsh", "--login"]
