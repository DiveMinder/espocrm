FROM espocrm/espocrm:latest

# Custom entrypoint to honor $PORT, fix perms, set ServerName
COPY docker-entrypoint.sh /usr/local/bin/start-espocrm.sh
RUN chmod +x /usr/local/bin/start-espocrm.sh

CMD ["/usr/local/bin/start-espocrm.sh"]
