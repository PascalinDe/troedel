#!/bin/bash


# options (defaults)
MAXIMUM=3;
STARTING_POINT=$HOME;
TOOL="";


# messages
HELP="open PDF file(s) matching regular expression";
USAGE="usage: pdfregex.sh [-h] [-m] [-p path] [-t tool] regex";
OPTIONS=$"options:
\n-h, --help\tshow this help message and exit
\n-m, --maximum\tnumber of PDF files to open (default: $MAXIMUM)
\n-p, --path\tstarting point (default: $HOME)
\n-t, --tool\tPDF viewer (default: user's preferred application)";


OPTION=""
for ARG in $@; do
	case "$ARG" in
		-h|--help)
			echo -e $HELP;
			echo -e $USAGE;
			echo -e $OPTIONS;
			exit;;
		-m|--maximum|-p|--path|-t|--tool)
			OPTION=$ARG;
			continue;;
		*)
			if [ -z "$OPTION" ]; then
				REGEX=$ARG;
				break;
			fi
			case "$OPTION" in
				-m|--maximum)
					MAXIMUM=$ARG;
					OPTION="";
					continue;;
				-p|--path)
					STARTING_POINT=$ARG;
					OPTION="";
					continue;;
				-t|--tool)
					TOOL=$ARG;
					OPTION="";
					continue;;
				*)
					echo -e "unknown option $OPTION";
					echo -e "$USAGE";
					exit;;
			esac
	esac
done


if [ -z "$REGEX" ]; then
	echo -e "missing argument regex";
	echo -e "$USAGE";
fi


FILES="$(find $STARTING_POINT -regex "$STARTING_POINT/$REGEX\.pdf")"
NUM=$(echo "$FILES" | wc -l)


if [ "$NUM" -gt "$MAXIMUM" ]; then
	echo "regex $REGEX matches $NUM/$MAXIMUM files";
	echo $FILES;
	exit;
fi


echo $FILES | while read LINE; do
	if [ -n "$TOOL" ]; then
		$TOOL $LINE;
	else
		xdg-open $LINE;
	fi
done
