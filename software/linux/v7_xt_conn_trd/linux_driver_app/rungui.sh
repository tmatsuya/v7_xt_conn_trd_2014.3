if [ $(getconf LONG_BIT) == "64" ]
then
echo "***** Driver Compiled 64*****"
sudo java -Djava.library.path=./gui/jnilib/64 -jar gui/XilinxGUI.jar
else
echo "***** Driver Compiled 32*****"
sudo java -Djava.library.path=./gui/jnilib/32 -jar gui/XilinxGUI.jar
fi

