#
# example of utilization:
# make -f makefile.mk build EXE=array_interface OBJS=array_interface.o
#

include $(ORACLE_HOME)/rdbms/lib/env_rdbms.mk

build: $(LIBCLNTSH) $(OBJS)
	$(BUILDEXE64)
	$(RM) -f $(OBJS)

