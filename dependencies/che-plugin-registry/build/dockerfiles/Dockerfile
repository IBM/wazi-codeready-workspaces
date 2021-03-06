#
# Copyright (c) 2018-2021 Red Hat, Inc.
# Copyright IBM Corporation 2020-2021
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
#   Red Hat, Inc. - initial API and implementation
#   IBM Corporation - implementation
#

# Builder: check meta.yamls and create index.json
# https://access.redhat.com/containers/?tab=tags#/registry.access.redhat.com/ubi8/python-38
FROM registry.access.redhat.com/ubi8/python-38:1-54.1618436884 as builder
USER 0

################# 
# PHASE ONE: create ubi8 image with yq
################# 

ARG BOOTSTRAP=false
ENV BOOTSTRAP=${BOOTSTRAP}
ARG USE_DIGESTS=false
ENV USE_DIGESTS=${USE_DIGESTS}

# to get all the python deps pre-fetched so we can build in Brew:
# 1. extract files in the container to your local filesystem
#    find v3 -type f -exec dos2unix {} \;

# NOTE: used to be in /root/.local but now can be found in /opt/app-root/src/.local
# CONTAINERNAME=pluginregistryoffline && \
# docker build -t ${CONTAINERNAME} . --no-cache  --target builder \
#   --build-arg BOOTSTRAP=true --build-arg USE_DIGESTS=false -f build/dockerfiles/Dockerfile 
# mkdir -p /tmp/root-local/ && docker run --rm -v \
#   /tmp/root-local/:/tmp/root-local/ ${CONTAINERNAME} /bin/bash \
#   -c 'cd /opt/app-root/src/.local/ && cp -r bin/ lib/ /tmp/root-local/'
# pushd /tmp/root-local >/dev/null && sudo tar czf root-local.tgz lib/ bin/ && popd >/dev/null && mv -f /tmp/root-local/root-local.tgz . && sudo rm -fr /tmp/root-local/

# 2. then add it to dist-git so it's part of this repo
#    rhpkg new-sources root-local.tgz 

# built in Brew, use tarball in lookaside cache; built locally, comment this out
# COPY root-local.tgz /tmp/root-local.tgz

# NOTE: uncomment for local build. Must also set full registry path in FROM to registry.redhat.io or registry.access.redhat.com
# enable rhel 7 or 8 content sets (from Brew) to resolve jq as rpm
COPY ./build/dockerfiles/content_set*.repo /etc/yum.repos.d/
COPY ./build/dockerfiles/rhel.install.sh /tmp
RUN /tmp/rhel.install.sh && rm -f /tmp/rhel.install.sh

COPY ./build/scripts/*.sh ./build/scripts/meta.yaml.schema /build/
COPY ./v3 /build/v3
WORKDIR /build/

# if only including the /latest/ plugins, apply this line to remove them from builder
# RUN ./keep_only_latest.sh
RUN ./generate_latest_metas.sh v3
RUN ./check_plugins_location.sh v3
RUN ./set_plugin_dates.sh v3
RUN ./check_metas_schema.sh v3
RUN ./swap_images.sh v3
RUN ./swap_plugins_memory.sh v3
RUN if [[ ${USE_DIGESTS} == "true" ]]; then ./write_image_digests.sh v3; fi
RUN ./index.sh v3 > /build/v3/plugins/index.json
RUN ./list_referenced_images.sh v3 > /build/v3/external_images.txt
RUN chmod -R g+rwX /build

################# 
# PHASE TWO: configure registry image
################# 

# Build registry, copying meta.yamls and index.json from builder
# UPSTREAM: use RHEL7/RHSCL/httpd image so we're not required to authenticate with registry.redhat.io
# https://access.redhat.com/containers/?tab=tags#/registry.access.redhat.com/rhscl/httpd-24-rhel7
FROM registry.access.redhat.com/rhscl/httpd-24-rhel7:2.4-136.1614612498 AS registry

# Build Arguments
ARG PRODUCT_VERSION=1.2.5

ENV PRODUCT="IBM Wazi Developer for Red Hat CodeReady Workspaces" \
    COMPANY="IBM" \
    VERSION=$PRODUCT_VERSION \
    RELEASE="1" \
    SUMMARY="IBM Wazi Developer for Workspaces" \
    DESCRIPTION="IBM Wazi Developer for Red Hat CodeReady Workspaces - Plugin" \
    PRODTAG="wazi-code-plugin"

LABEL name="$PRODUCT" \
      vendor="$COMPANY" \
      version="$VERSION" \
      release="$RELEASE" \
      license="EPLv2" \
      summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="$SUMMARY" \
      io.openshift.tags="$PRODTAG,$COMPANY" \
      com.redhat.component="$PRODTAG" \
      io.openshift.expose-services="" \
      productName="$PRODUCT" \
      productVersion="$VERSION"

# DOWNSTREAM: use RHEL8/httpd
# https://access.redhat.com/containers/?tab=tags#/registry.access.redhat.com/rhel8/httpd-24
# FROM registry.redhat.io/rhel8/httpd-24:1-130.1618434979 AS registry
USER 0

# latest httpd container doesn't include ssl cert, so generate one
RUN chmod +x /usr/share/container-scripts/httpd/pre-init/40-ssl-certs.sh && \
    /usr/share/container-scripts/httpd/pre-init/40-ssl-certs.sh
RUN \
    yum -y -q update && \
    yum -y -q clean all && rm -rf /var/cache/yum && \
    echo "Installed Packages" && rpm -qa | sort -V && echo "End Of Installed Packages"
# Fix for htaccess from VA Scan
RUN echo "<FilesMatch "\""^\\.ht"\"">" >> /etc/httpd/conf/httpd.conf && \
    echo "Require all denied" >> /etc/httpd/conf/httpd.conf && \
    echo "</FilesMatch>" >> /etc/httpd/conf/httpd.conf
# Fix for SSL from VA Scan
RUN sed -i /etc/httpd/conf.d/ssl.conf \
    -e "s,SSLProtocol all -SSLv2,SSLProtocol all -SSLv3," \
    -e "s,SSLCipherSuite HIGH:MEDIUM:!aNULL:!MD5,SSLCipherSuite HIGH:!aNULL:!MD5,"

# BEGIN these steps might not be required
RUN sed -i /etc/httpd/conf/httpd.conf \
    -e "s,Listen 80,Listen 8080," \
    -e "s,logs/error_log,/dev/stderr," \
    -e "s,logs/access_log,/dev/stdout," \
    -e "s,AllowOverride None,AllowOverride All," && \
    chmod a+rwX /etc/httpd/conf /run/httpd /etc/httpd/logs/
STOPSIGNAL SIGWINCH
# END these steps might not be required

WORKDIR /var/www/html

RUN mkdir -m 777 /var/www/html/v3
COPY README.md .htaccess /var/www/html/
COPY --from=builder /build/v3 /var/www/html/v3
COPY ./LICENSE /licenses/
COPY ./build/dockerfiles/rhel.entrypoint.sh ./build/dockerfiles/entrypoint.sh /usr/local/bin/
RUN chmod g+rwX /usr/local/bin/entrypoint.sh /usr/local/bin/rhel.entrypoint.sh && \
    chgrp -R 0 /var/www/html && chmod -R g+rw /var/www/html
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/local/bin/rhel.entrypoint.sh"]

# Offline build: cache .theia and .vsix files in registry itself and update metas
# multiple temp stages does not work in Brew
FROM builder AS offline-builder
RUN ./cache_artifacts.sh v3 && \
    chmod -R g+rwX /build

FROM registry AS offline-registry
COPY --from=offline-builder /build/v3 /var/www/html/v3

# append Brew metadata here
