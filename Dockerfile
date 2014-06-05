FROM lehmannro/squeak
ADD run.st /
ADD repository/ /repository
CMD /run.sh
