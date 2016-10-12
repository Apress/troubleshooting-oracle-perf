#
# example of utilization:
# make -f makefile.mk build EXE=session_attributes OBJS=session_attributes.o
#

include $(ORACLE_HOME)/rdbms/lib/env_rdbms.mk

build: $(LIBCLNTSH) $(OBJS)
	$(BUILDEXE64)
	$(RM) -f $(OBJS)
