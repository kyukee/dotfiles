#!/bin/bash

printf "\nb line_number		   create breakpoint\n"
printf "b file.c:line_number		   \n"
printf "b function_name		   \n\n"
printf "r  	   		   start running program\n"
printf "r < input.txt  	   	   start running program with an input file\n\n"
printf "bt			   backtrace - go to the instruction that caused an error\n\n"
printf "l  		   	   list - show code near current line\n\n"
printf "p variable                 print value of variable\n\n"

printf "info b			   list all breakpoints\n"
printf "disable breakpoint_num	   disable a breakpoint\n\n"
printf "s 			   execute next line\n"
printf "n 			   execute next line (without going into functions)\n"
printf "c			   continue until next breakpoint\n\n"
printf "q			   quit\n"
