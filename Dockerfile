# Copyright (c) 2018-2020 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
#   Red Hat, Inc. - initial API and implementation
#

# https://access.redhat.com/containers/?tab=tags#/registry.access.redhat.com/ubi8-minimal
FROM registry.access.redhat.com/ubi8-minimal:8.2-345
USER root
ENV CHE_HOME=/home/user/codeready
ENV JAVA_HOME=/usr/lib/jvm/jre
RUN microdnf install java-11-openjdk-headless tar gzip shadow-utils findutils && \
    microdnf update -y gnutls && \
    microdnf -y clean all && rm -rf /var/cache/yum && echo "Installed Packages" && rpm -qa | sort -V && echo "End Of Installed Packages" && \
    adduser -G root user && mkdir -p /home/user/codeready && \
    # copy cacert to home dir - see file references in entrypoint.sh
    cp /etc/pki/ca-trust/extracted/java/cacerts /home/user/cacerts

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]


# NOTE: if built in Brew, use get-sources-jenkins.sh to pull latest
COPY assembly/codeready-workspaces-assembly-main/target/codeready-workspaces-assembly-main.tar.gz /tmp/codeready-workspaces-assembly-main.tar.gz
RUN tar xzf /tmp/codeready-workspaces-assembly-main.tar.gz --transform="s#.*codeready-workspaces-assembly-main/*##" -C /home/user/codeready && rm -f /tmp/codeready-workspaces-assembly-main.tar.gz

# this should fail if the startup script is not found in correct path /home/user/codeready/tomcat/bin/catalina.sh
RUN mkdir /logs /data && \
    chmod 0777 /logs /data && \
    chgrp -R 0 /home/user /logs /data && \
    chown -R user /home/user && \
    chmod -R g+rwX /home/user && \
    find /home/user -type d -exec chmod 777 {} \; && \
    # set group write permission so that entrypoint.sh can update permissions once file is updated w/ new cert
    chmod 777 /home/user/cacerts && \
    java -version && echo -n "Server startup script in: " && \
    find /home/user/codeready -name catalina.sh | grep -z /home/user/codeready/tomcat/bin/catalina.sh

USER user

# append Brew metadata here
