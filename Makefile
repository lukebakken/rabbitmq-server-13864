.PHONY: certs
certs:
	git submodule update --init
	make -C tls-gen/basic CN=localhost
	cp -vf $(CURDIR)/tls-gen/basic/result/* certs
	chmod 0664 certs/*

.PHONY: rmq
rmq:
	docker run --pull always --rm --name rabbitmq --mount "type=bind,src=$(CURDIR)/certs,dst=/etc/rabbitmq/certs,ro" --mount "type=bind,src=$(CURDIR)/rabbitmq.conf,dst=/etc/rabbitmq/rabbitmq.conf,ro" --publish 5671:5671 --publish 15671:15671 rabbitmq:4-management

.PHONY: s_client
s_client:
	openssl s_client -connect localhost:5671 -tls1_2 -CAfile $(CURDIR)/certs/ca_certificate.pem
