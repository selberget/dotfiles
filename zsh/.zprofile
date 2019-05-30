# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# set PATH for spark
export SPARK_HOME="/usr/local/spark"
if [ -d "$SPARK_HOME/bin" ] ; then
    PATH="$SPARK_HOME/bin:$PATH"
fi

#set PATH for Anaconda
if [ -d "/home/johan/anaconda3/bin" ] ; then
    PATH="/home/johan/anaconda3/bin:$PATH"
fi

# Automate startup of X via tty1
if [ -z $DISPLAY ] && [ $(tty) = /dev/tty1 ]; then
	exec startx
fi
