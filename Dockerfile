FROM ubuntu
ENV HOME=/home/home
ENV TERM=xterm

RUN apt update
RUN apt upgrade -y
RUN apt install -y curl

WORKDIR $HOME
COPY . ./dotfiles
RUN ./dotfiles/install.sh
RUN ./dotfiles/install.sh buildtools
RUN chsh -s /bin/zsh
CMD /bin/zsh
