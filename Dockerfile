FROM ubuntu:16.04

# Locales
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8
RUN apt-get update && apt-get install -y locales && locale-gen en_US.UTF-8

# Colors and italics for tmux
COPY xterm-256color-italic.terminfo /root
RUN tic /root/xterm-256color-italic.terminfo
ENV TERM=xterm-256color-italic

# Common packages
RUN apt-get update && apt-get install -y \
      build-essential \
      curl \
      git  \
      iputils-ping \
      jq \
      libncurses5-dev \
      libevent-dev \
      net-tools \
      netcat-openbsd \
      rubygems \
      ruby-dev \
      silversearcher-ag \
      socat \
      software-properties-common \
      tmux \
      tzdata \
      wget \
      zsh 
RUN chsh -s /usr/bin/zsh

# Install tmux
WORKDIR /usr/local/src
RUN wget https://github.com/tmux/tmux/releases/download/2.5/tmux-2.5.tar.gz
RUN tar xzvf tmux-2.5.tar.gz
WORKDIR /usr/local/src/tmux-2.5
RUN ./configure
RUN make 
RUN make install
RUN rm -rf /usr/local/src/tmux*

# Install neovim
RUN add-apt-repository ppa:neovim-ppa/unstable
RUN apt-get update
RUN apt-get install neovim -y

# install vim-plug
RUN sh -c 'curl -fLo /root/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Install NodeJs
RUN curl -sL https://deb.nodesource.com/setup_current.x | bash -
RUN apt-get install -y nodejs
RUN apt-get install -y build-essential
RUN npm install -g @angular/cli

# Install python3
RUN apt-get install -y \
	python3 \
	python3-pip

# Install fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
RUN ~/.fzf/install --key-bindings --completion --update-rc
#RUN source ~/.zshrc

# Install java
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/ && \
    rm -rf /var/cache/oracle-jdk8-installer;

#ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

RUN apt-get update && apt-get install dos2unix -y
COPY init.vim /root/.config/nvim/init.vim
RUN dos2unix /root/.config/nvim/init.vim

RUN nvim --headless +PlugInstall +qall

RUN alias 'vim=nvim'
RUN alias 'vi=nvim'

WORKDIR /src
