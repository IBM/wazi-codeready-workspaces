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

# https://access.redhat.com/containers/?tab=tags#/registry.access.redhat.com/ubi8/openjdk-8
FROM registry.redhat.io/ubi8/openjdk-8:1.3-2.1591609345
USER root

COPY entrypoint.sh /entrypoint.sh
RUN mkdir -p /home/jboss/codeready

# NOTE: if built in Brew, use get-sources-jenkins.sh to pull latest
# OR, if you intend to build the Che Server tarball locally, 
# see https://github.com/redhat-developer/codeready-workspaces-productization/blob/master/devdoc/building/building-crw.adoc#make-changes-to-crw-and-re-deploy-to-minishift
# then copy /home/${USER}/projects/codeready-workspaces/assembly/codeready-workspaces-assembly-main/target/codeready-workspaces-assembly-main.tar.gz into this folder
COPY assembly/codeready-workspaces-assembly-main/target/codeready-workspaces-assembly-main.tar.gz /tmp/codeready-workspaces-assembly-main.tar.gz
RUN tar xzf /tmp/codeready-workspaces-assembly-main.tar.gz --transform="s#.*codeready-workspaces-assembly-main/*##" -C /home/jboss/codeready && \
    rm -f /tmp/codeready-workspaces-assembly-main.tar.gz
# this should fail if the startup script is not found in correct path /home/jboss/codeready/tomcat/bin/catalina.sh
RUN echo -n "Server startup script in: " && find /home/jboss/codeready -name catalina.sh | grep -z /home/jboss/codeready/tomcat/bin/catalina.sh

RUN microdnf update -y gnutls && microdnf -y clean all && rm -rf /var/cache/yum && \
    echo "Installed Packages" && rpm -qa | sort -V && echo "End Of Installed Packages"

RUN cp /etc/pki/java/cacerts /home/jboss/cacerts && chmod 644 /home/jboss/cacerts && \
    mkdir -p /logs /data && \
    chgrp -R 0     /home/jboss /data /logs && \
    chmod -R g+rwX /home/jboss /data /logs && \
    chown -R jboss /home/jboss

USER jboss
ENTRYPOINT ["/entrypoint.sh"]

ENV SUMMARY="Red Hat CodeReady Workspaces Server container" \
    DESCRIPTION="Red Hat CodeReady Workspaces server container" \
    PRODNAME="codeready-workspaces" \
    COMPNAME="server-rhel8"

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="$DESCRIPTION" \
      io.openshift.tags="$PRODNAME,$COMPNAME" \
      com.redhat.component="$PRODNAME-$COMPNAME-container" \
      name="$PRODNAME/$COMPNAME" \
      version="2.2" \
      license="EPLv2" \
      maintainer="Nick Boldt <nboldt@redhat.com>" \
      io.openshift.expose-services="" \
      usage=""

