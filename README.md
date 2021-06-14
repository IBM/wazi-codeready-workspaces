[![Build Status](https://travis-ci.com/IBM/wazi-codeready-workspaces.svg?branch=main)](https://travis-ci.com/IBM/wazi-codeready-workspaces)
[![Release](https://img.shields.io/github/release/IBM/wazi-codeready-workspaces.svg)](../../releases/latest)
[![License](https://img.shields.io/github/license/IBM/wazi-codeready-workspaces)](LICENSE)
[![DockerHub](https://img.shields.io/badge/DockerHub-DevFile-blue?color=3498db)](https://hub.docker.com/repository/docker/ibmcom/wazi-code-dev-file)
[![DockerHub](https://img.shields.io/badge/DockerHub-Plugin-blue?color=3498db)](https://hub.docker.com/repository/docker/ibmcom/wazi-code-plugin)
[![Documentation](https://img.shields.io/badge/Documentation-blue?color=1f618d)](https://ibm.biz/wazi-crw-doc)
    
# IBM Wazi Developer for Workspaces

IBM Wazi Developer for Red Hat CodeReady Workspaces (IBM Wazi Developer for Workspaces), delivers cloud-native developer experience, enabling development and testing of IBM z/OS application components in containerized, z/OS sandbox environment on Red Hat OpenShift Container Platform running on x86 hardware, and providing capability to deploy applications into production on native z/OS running on IBM Z hardware. IBM Wazi Developer is a development environment that provides an in-browser IDE with a single-click developer workspace with the capabilities to code, edit, build, and debug.  
  
IBM Wazi Developer for Workspaces is built on the Red Hat CodeReady Workspaces project. The core functionality for Red Hat CodeReady Workspaces is provided by an open-source project called Eclipse Che. IBM Wazi Developer for Workspaces uses Kubernetes and containers to provide your team with a consistent, secure, and zero-configuration development environment that interacts with your IBM Z platform.  

- This repository is based off of the upstream [Red Hat CodeReady for Workspaces](https://github.com/redhat-developer/codeready-workspaces), where the code is in other upstream repositories by the [Eclipse Foundation](https://github.com/eclipse/).
  
## Documentation
  
Documentation can be found here for [IBM Wazi Developer for Workspaces](https://ibm.biz/wazi-crw-doc)  
  
* The [IBM Wazi Developer for Workspaces](https://github.com/ibm/wazi-codeready-workspaces) repository - provides the devfile and plug-in registries for the Red Hat CodeReady Workspaces.
* The [IBM Wazi Developer for Workspaces Sidecars](https://github.com/ibm/wazi-codeready-workspaces-sidecars) repository - provides the supporting resources for the devfile and plug-in registries.
* The [IBM Wazi Developer for Workspaces Operator](https://github.com/ibm/wazi-codeready-workspaces-operator) repository - provides the Operator Lifecycle Manager for deployment.

## Feadback
  
We would love to hear feedback from you about IBM Wazi Developer for Red Hat CodeReady Workspaces.  
File an issue or provide feedback here: [IBM Wazi Developer for Workspaces Issues](https://github.com/IBM/wazi-codeready-workspaces/issues)

## IBM Wazi Developer for Red Hat CodeReady Workspaces
IBM Wazi Developer for Red Hat CodeReady Workspaces (IBM Wazi Developer) is a single integrated solution, which delivers a cloud native development experience for z/OS. It enables application developers to develop and test z/OS application components in a virtual z/OS environment on an OpenShift®-powered hybrid multicloud platform, and to use an industry standard integrated development environment (IDE) of their choice. 
  
IBM Wazi Developer for Workspaces, a component of IBM Wazi Developer, is built on the Red Hat CodeReady Workspaces project. The core functionality for Red Hat CodeReady Workspaces is provided by an open-source project called Eclipse Che. IBM Wazi Developer for Workspaces uses Kubernetes and containers to provide your team with a consistent, secure, and zero-configuration development environment that interacts with your IBM Z platform.  
  
IBM Wazi Developer for Workspaces provides a modern experience for mainframe software developers working with z/OS applications in the cloud. Powered by the open-source projects Zowe and Red Hat CodeReady Workspaces, IBM Wazi Developer for Workspaces offers an easy, streamlined onboarding process to provide mainframe developers the tools they need. Using container technology and stacks, IBM Wazi Developer for Workspaces brings the necessary technology to the task at hand.

### Details
IBM Wazi Developer for Workspaces provides a custom stack for mainframe developers with the all-in-one mainframe development package that includes the following capabilities:

- Modern mainframe editor with rich language support for COBOL, JCL, Assembler (HLASM), and PL/I, which provides language-specific features such as syntax highlighting, outline view, declaration hovering, code completion, snippets, a preview of copybooks, copybook navigation, and basic refactoring using [IBM Z Open Editor](https://marketplace.visualstudio.com/items?itemName=IBM.zopeneditor)
- Source code management (SCM) integration to enable integration with any flavor of Git, a popular and modern parallel development SCM
- Intelligent build capability that enables developers to perform a user build with IBM Dependency Based Build for any flavor of Git
- Integrations that enable developers to work with z/OS resources such as MVS and UNIX files and JES jobs
- Connectivity to Z host using [Zowe Explorer](https://marketplace.visualstudio.com/items?itemName=Zowe.vscode-extension-for-zowe)
- Connectivity to Z host using [IBM Remote System Explorer API](https://ibm.github.io/zopeneditor-about/Docs/interact_zos_overview.html)
- Debugging COBOL and PL/I applications using [IBM Z Open Debug](https://developer.ibm.com/mainframe/2020/06/12/introducing-ibm-z-open-debug/)
- Mainframe Development package with a custom plug-in and devfile registry support using the [IBM Wazi Developer stack](https://github.com/IBM/wazi-codeready-workspaces)

### Prerequisites
- Ensure that you have a connection to a Red Hat OpenShift Container Platform (OCP) cluster, and that you have cluster-admin permissions.
- The Red Hat OpenShift cluster must be configured with a default storage class. For more information, see OpenShift Container Platform documentation.
- If you plan to use the OpenShift oAuth, then the cluster oAuth must be configured. For more information, see Configuring the internal OAuth server.
- Install OpenShift command-line tool, which lets you create applications and manage OpenShift Container Platform projects from a terminal.
- Install IBM Cloud Pak® command-line tool, which is a command line tool to manage Container Application Software for Enterprises (CASEs).
  
---
  
**_Red Hat Content_**  
 
# What's inside?

NOTE: the so-called master branch is deprecated and is no longer kept up to date. Instead, the latest nightly sources are in **crw-2-rhel-8 branch**, synced to upstream projects' main (or master) branches.

For the latest stable release, see the **crw-2.y-rhel-8** branch with the largest y value.

---

This repository hosts CodeReady Workspaces assembly that mainly inherits Eclipse Che artifacts and repackages some of them:

Differences as compared to upstream:

* Customized Dashboard (pics, icons, titles, loaders, links)
* Samples and Stacks modules
* Bayesian Language Server and agent
* Product Info plugin (IDE customizations: pics, titles links)
* Custom Dockerfile based on official RH OpenJDK image from RHCC

NOTE: Dockerfiles in this repo are NOT the ones used to build RHCC container images in OSBS.

## How to Build

### Pre-reqs

JDK 1.8+
Maven 3.5+

### Build Assembly

Run the following command in the root of a repository:

```
mvn clean install
```

The build artifact used in the container image will be in `assembly/codeready-worksapces-assembly-main/target`


### How to Build Container Image Locally

First, build the CRW assembly in this repo:

```
mvn clean install
```

Then just use the `Dockerfile` in this repo to build:

```
podman build --force-rm -t registry.redhat.io/codeready-workspaces/server-rhel8:2.y . && \
podman images | grep registry.redhat.io/codeready-workspaces/server-rhel8:2.y
```

You can then reference this image in your deployment (set image pull policy to *`Always`* to make sure it's pulled instead of the default one).

For more info on how to test locally built changes in a local OKD 3.11 (Minishift 1.34) cluster, see [Build CodeReady Workspaces server container locally and deploy using Minishift](devdoc/building/building-crw.adoc#make-changes-to-crw-and-re-deploy-to-minishift).


**NOTE**

---

Once published, images will be in locations like these:

* registry.redhat.io/codeready-workspaces/configbump-rhel8
* registry.redhat.io/codeready-workspaces/crw-2-rhel8-operator
* registry.redhat.io/codeready-workspaces/crw-2-rhel8-operator-metadata
* registry.redhat.io/codeready-workspaces/devfileregistry-rhel8
* registry.redhat.io/codeready-workspaces/imagepuller-rhel8
* registry.redhat.io/codeready-workspaces/jwtproxy-rhel8
* registry.redhat.io/codeready-workspaces/machineexec-rhel8
* registry.redhat.io/codeready-workspaces/pluginbroker-artifacts-rhel8
* registry.redhat.io/codeready-workspaces/pluginbroker-metadata-rhel8
* registry.redhat.io/codeready-workspaces/plugin-java11-openj9-rhel8
* registry.redhat.io/codeready-workspaces/plugin-java11-rhel8
* registry.redhat.io/codeready-workspaces/plugin-java8-openj9-rhel8
* registry.redhat.io/codeready-workspaces/plugin-java8-rhel8
* registry.redhat.io/codeready-workspaces/plugin-kubernetes-rhel8
* registry.redhat.io/codeready-workspaces/plugin-openshift-rhel8
* registry.redhat.io/codeready-workspaces/pluginregistry-rhel8
* registry.redhat.io/codeready-workspaces/server-rhel8
* registry.redhat.io/codeready-workspaces/stacks-cpp-rhel8
* registry.redhat.io/codeready-workspaces/stacks-dotnet-rhel8
* registry.redhat.io/codeready-workspaces/stacks-golang-rhel8
* registry.redhat.io/codeready-workspaces/stacks-php-rhel8
* registry.redhat.io/codeready-workspaces/theia-endpoint-rhel8
* registry.redhat.io/codeready-workspaces/theia-rhel8
* registry.redhat.io/codeready-workspaces/traefik-rhel8

---

### How to Build Container Using Jenkins and OSBS/Brew (REQUIRES VPN)

See this document for how to use those build systems, in order to publish a container image to Red Hat Container Catalog:

* https://github.com/redhat-developer/codeready-workspaces-productization/blob/master/devdoc/building/osbs-container-builds.adoc

See also:

* https://main-jenkins-csb-crwqe.apps.ocp4.prod.psi.redhat.com/job/CRW_CI/ (crw-server_*)
* https://github.com/redhat-developer/codeready-workspaces-images#jenkins-jobs

### How to Build CRW Server Container Locally (REQUIRES VPN)

If you have access to Red Hat VPN, clone the pkgs.devel repo, then run the `get-sources-jenkins.sh` script to pull the latest dependency tarball into the local project, and trigger a Brew build.

```
kinit
git clone ssh://kerberos-username@pkgs.devel.redhat.com/containers/codeready-workspaces
cd codeready-workspaces
./get-sources-jenkins.sh
```

### Keeping CRW Server in sync with upstream and downstream

Upstream: https://github.com/eclipse/che
Midstream: (this repo)
Downstream: http://pkgs.devel.redhat.com/cgit/containers/codeready-workspaces/tree/?h=crw-2-rhel-8

Sync jobs:

* https://main-jenkins-csb-crwqe.apps.ocp4.prod.psi.redhat.com/job/CRW_CI/ (crw-server_*)
* https://gitlab.cee.redhat.com/codeready-workspaces/crw-jenkins/-/tree/master/jobs/CRW_CI (sources)
* https://github.com/redhat-developer/codeready-workspaces-images#jenkins-jobs (copied sources)

The Jenkinsfile in this repo has moved. See:

* https://gitlab.cee.redhat.com/codeready-workspaces/crw-jenkins/-/tree/master/jobs/CRW_CI
* https://github.com/redhat-developer/codeready-workspaces-images#jenkins-jobs


### Keeping CRW dependencies in sync with upstream and downstream

Folders under [/dependencies](dependencies) are synced to https://github.com/redhat-developer/codeready-workspaces-images. If no matching project exists under the link:dependencies[/dependencies] folder, sync occurs directly from an upstream Che project.

Sync jobs:

* https://main-jenkins-csb-crwqe.apps.ocp4.prod.psi.redhat.com/job/CRW_CI/ (jobs)
* https://gitlab.cee.redhat.com/codeready-workspaces/crw-jenkins/-/tree/master/jobs/CRW_CI (sources)
* https://github.com/redhat-developer/codeready-workspaces-images#jenkins-jobs (copied sources)

These files have moved, as they sync directly from an upstream repo:

    * dependencies/che-jwtproxy/Jenkinsfile
    * dependencies/che-machine-exec/Jenkinsfile
    * dependencies/che-pluginbroker/Jenkinsfile
    * dependencies/configbump/Jenkinsfile
    * dependencies/kubernetes-image-puller/Jenkinsfile
    * dependencies/push-latest.Jenkinsfile
    * dependencies/send-email-qe-build-list.Jenkinsfile
    * dependencies/traefik/Jenkinsfile
    * dependencies/update-digests.Jenkinsfile


## Branding

Branding is currently in two places.

### Dashboard

To reskin the Che server assembly, you need to edit the following files, which are used in the [Che Dashboard](https://github.com/eclipse/che-dashboard/tree/master/assets/branding):

* [assembly/branding/branding-crw.css](assembly/branding/branding-crw.css) - replacement for [Che default css](https://github.com/eclipse/che-dashboard/tree/master/assets/branding/branding.css), copied via [Jenkinsfile](https://github.com/redhat-developer/codeready-workspaces-images/blob/crw-2-rhel-8/crw-jenkins/jobs/CRW_CI/crw-server_2.x.jenkinsfile) during Pipeline build

* link:assembly/branding/product.json.template[assembly/branding/product.json.template]
** link:assembly/branding/favicon.ico[assembly/branding/favicon.ico] - browser tab favicon
** link:assembly/branding/che-logo-text.svg[assembly/branding/che-logo-text.svg] - top left wordmark
** link:assembly/branding/che-logo.svg[assembly/branding/che-logo.svg] - bottom left icon
** link:assembly/branding/loader.svg[assembly/branding/loader.svg] - dashboard loading animation

See also SVG assets in link:product/branding/[product/branding/] folder.

NOTE: In a future release, the Che Dashboard will be a separate deployment from the Che Server, which means the above information may become incorrect.

### Theia

In addition to the Che Dashboard branding, there is also branding elements for [Che Theia](https://github.com/eclipse-che/che-theia). See details in [codeready-workspaces-theia/conf/theia/branding](https://github.com/redhat-developer/codeready-workspaces-theia/tree/crw-2-rhel-8/conf/theia/branding). 

### A note about SVG files 

If using Inkscape to save files, make sure you export as *Plain SVG*, then edit the resulting .svg file to remove any `<metadata>...</metadata>` tags and all their contents. You can also remove the `xmlns:rdf` definition. This will ensure they compile correctly.
