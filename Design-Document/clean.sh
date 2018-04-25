#!/bin/bash
if [ -e *.aux ] ; then rm *.aux fi 
if [ -e *.log ] ; then rm *.log fi
if [ -e *.out ] ; then rm *.out fi
if [ -e *.gz  ] ; then rm *.gz  fi
if [ -e *.toc ] ; then rm *.toc fi