all: mysql-protocol.r

mysql-protocol.r: mysql-protocol-pre.r
	$(shell) sed "s/<DATE>/`date +%F`/" $< > $@  && sed -i "s/<GIT-COMMIT-ID>/`git log -n 1|head -1|awk '{print $$2}'`/" $@

clean:
	rm mysql-protocol.r
