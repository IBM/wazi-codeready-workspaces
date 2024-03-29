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
FROM registry.access.redhat.com/ubi8/python-38:1-60 as builder
USER 0

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

COPY ./build/scripts/*.sh /build/
COPY che-*.yaml /build/
COPY resources.tgz /build/
COPY ./v3/plugins/ /build/v3/plugins/
COPY ./v3/images/*.png /build/v3/images/
WORKDIR /build/

RUN tar -xvf resources.tgz -C ./
RUN rm -rf ./output/v3/che-theia-plugins.yaml ./output/v3/che-editors.yaml ./output/v3/che-plugins.yaml
RUN ./swap_images.sh ./output/v3 --use-generated-content
RUN ./swap_plugins_memory.sh ./output/v3
RUN if [[ ${USE_DIGESTS} == "true" ]]; then ./write_image_digests.sh ./output/v3; fi
RUN ./list_referenced_images.sh ./output/v3 --use-generated-content > /build/output/v3/external_images.txt && cat /build/output/v3/external_images.txt
RUN chmod -R g+rwX /build

# Build registry, copying meta.yamls and index.json from builder
# https://access.redhat.com/containers/?tab=tags#/registry.access.redhat.com/ubi8/httpd-24
FROM registry.access.redhat.com/ubi8/httpd-24:1-161 AS registry
USER 0

# Build Arguments
ARG PRODUCT_VERSION=1.4.1

ENV PRODUCT="IBM Wazi Developer for Red Hat CodeReady Workspaces" \
    COMPANY="IBM" \
    VERSION=$PRODUCT_VERSION \
    RELEASE="1" \
    SUMMARY="IBM Wazi Developer for Workspaces" \
    DESCRIPTION="IBM Wazi Developer for Red Hat CodeReady Workspaces - Plugin" \
    PRODTAG="ibm-wazi-developer-for-workspaces-plugin" \
    CLOUDPAK_ID="9d41d2d8126f4200b62ba1acc0dffa2e" \
    CLOUDPAK_METRIC="VIRTUAL_PROCESSOR_CORE" \
    PRODUCT_NAME="Code" \
    PRODUCT_ID="0e775d0d3f354a5ca074a6a4398045f3" \
    PRODUCT_METRIC="AUTHORIZED_USER" \
    PRODUCT_CHARGED_CONTAINERS="All" \
    PRODUCT_CLOUDPAK_RATIO="5:1"

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
      cloudpakName="$PRODUCT" \
      cloudpakId="$CLOUDPAK_ID" \
      cloudpakMetric="$CLOUDPAK_METRIC" \
      productName="$PRODUCT_NAME" \
      productVersion="$VERSION" \
      productID="$PRODUCT_ID" \
      productMetric="$PRODUCT_METRIC" \
      productChargedContainers="$PRODUCT_CHARGED_CONTAINERS" \
      productCloudpakRatio="$PRODUCT_CLOUDPAK_RATIO"

# latest httpd container doesn't include ssl cert, so generate one
RUN chmod +x /usr/share/container-scripts/httpd/pre-init/40-ssl-certs.sh && \
    /usr/share/container-scripts/httpd/pre-init/40-ssl-certs.sh

RUN \
    yum -y -q --nobest update && \
    yum -y -q clean all && rm -rf /var/cache/yum && \
    echo "Installed Packages" && rpm -qa | sort -V && echo "End Of Installed Packages"

RUN sed -i /etc/httpd/conf.d/ssl.conf \
    -e "s,.*SSLProtocol.*,SSLProtocol all -SSLv3," \
    -e "s,.*SSLCipherSuite.*,SSLCipherSuite HIGH:!aNULL:!MD5,"

RUN sed -i /etc/httpd/conf/httpd.conf \
    -e "s,\.ht\*,^\\\.ht," \
    -e "s,Files,FilesMatch,"

RUN sed -i /etc/httpd/conf/httpd.conf \
    -e "s,Listen 80,Listen 8080," \
    -e "s,logs/error_log,/dev/stderr," \
    -e "s,logs/access_log,/dev/stdout," \
    -e "s,AllowOverride None,AllowOverride All," && \
    chmod a+rwX /etc/httpd/conf /run/httpd /etc/httpd/logs/
STOPSIGNAL SIGWINCH

WORKDIR /var/www/html

RUN mkdir -m 777 /var/www/html/v3
COPY ./LICENSE /licenses/
COPY README.md .htaccess /var/www/html/
COPY --from=builder /build/output/v3 /var/www/html/v3
COPY --from=builder /build/v3/plugins/ /var/www/html/v3/plugins/
COPY --from=builder /build/v3/images/ /var/www/html/v3/images/
COPY ./build/dockerfiles/rhel.entrypoint.sh ./build/dockerfiles/entrypoint.sh /usr/local/bin/
RUN chmod g+rwX /usr/local/bin/entrypoint.sh /usr/local/bin/rhel.entrypoint.sh && \
    chgrp -R 0 /var/www/html && chmod -R g+rw /var/www/html
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/local/bin/rhel.entrypoint.sh"]

# append Brew metadata here
