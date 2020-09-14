[![Build Status](https://travis-ci.com/IBM/wazi-codeready-workspaces.svg?branch=main)](https://travis-ci.com/IBM/wazi-codeready-workspaces)
[![Release](https://img.shields.io/github/release/IBM/wazi-codeready-workspaces.svg)](../../releases/latest)
[![License](https://img.shields.io/github/license/IBM/wazi-codeready-workspaces)](LICENSE)
[![DockerHub](https://img.shields.io/badge/DockerHub-DevFile-blue?color=3498db)](https://hub.docker.com/repository/docker/ibmcom/wazi-code-dev-file)
[![DockerHub](https://img.shields.io/badge/DockerHub-Plugin-blue?color=3498db)](https://hub.docker.com/repository/docker/ibmcom/wazi-code-plugin)
[![Knowledge Center](https://img.shields.io/badge/Knowledge%20Center-blue?color=1f618d)](https://www.ibm.com/support/knowledgecenter/SSCH39)
    
# IBM&reg; Wazi Developer for Red Hat&reg; CodeReady Workspaces

IBM Wazi Developer for Red Hat CodeReady Workspaces (IBM Wazi Developer for Workspaces), delivers cloud-native developer experience, enabling development and testing of IBM z/OS application components in containerized, z/OS sandbox environment on Red Hat OpenShift Container Platform running on x86 hardware, and providing capability to deploy applications into production on native z/OS running on IBM Z hardware. IBM Wazi Developer is a development environment that provides an in-browser IDE with a single-click developer workspace with the capabilities to code, edit, build, and debug.  
  
## Features

IBM Wazi Developer for Workspaces provides a custom stack for mainframe developers with the all-in-one mainframe development package that includes the following capabilities:

- Modern mainframe editor with rich language support for COBOL, JCL, Assembler (HLASM), and PL/I that provide language-specific features such as syntax highlighting, outline view, declaration hovering, code completion, snippets, a preview of copybooks, copybook navigation, and basic refactoring using [IBM Z Open Editor](https://marketplace.visualstudio.com/items?itemName=IBM.zopeneditor)
- Source code management (SCM) integration to enable integration with any flavor of Git, a popular and modern parallel development SCM
- Intelligent build capability that enables developers to perform a user build with IBM Dependency Based Build for any flavor of Git
- Integrations that enable developers to work with z/OS resources such as MVS and UNIX files and JES jobs
- Connectivity to Z host using [Zowe Explorer](https://marketplace.visualstudio.com/items?itemName=Zowe.vscode-extension-for-zowe)
- Debugging COBOL and PL/I applications using [IBM Z Open Debug](https://developer.ibm.com/mainframe/2020/06/12/introducing-ibm-z-open-debug/)
- Interacting with the [IBM Remote System Explorer API](https://ibm.github.io/zopeneditor-about/Docs/interact_zos_overview.html)
- Mainframe Development package with custom plugin and devfile registry support using the [IBM Wazi Developer stack](https://github.com/IBM/wazi-codeready-workspaces)
    
## Documentation
  
Documentation can be found here for [IBM Wazi Developer for Workspaces](https://www.ibm.com/support/knowledgecenter/SSCH39)  
  
* The [IBM Wazi Developer for Workspaces](https://github.com/ibm/wazi-codeready-workspaces) repository - provides the devfile and plug-in registries for the Red Hat CodeReady Workspaces.
* The [IBM Wazi Developer for Workspaces Sidecars](https://github.com/ibm/wazi-codeready-workspaces-sidecars) repository - provides the supporting resources for the devfile and plug-in registries.
* The [IBM Wazi Developer for Workspaces Operator](https://github.com/ibm/wazi-codeready-workspaces-operator) repository - provides the Operator Lifecycle Manager for deployment.
  
## Feadback
  
We would love to hear feedback from you about IBM Wazi Developer for Red Hat CodeReady Workspaces.  
File an issue or provide feedback here: [IBM Wazi Developer for Workspaces Issues](https://github.com/IBM/wazi-codeready-workspaces/issues)
  
## What is IBM Wazi Developer for Workspaces?
  
IBM Wazi Developer for Workspaces is built on the Red Hat CodeReady Workspaces project. The core functionality for Red Hat CodeReady Workspaces is provided by an open-source project called Eclipse Che. IBM Wazi Developer for Workspaces uses Kubernetes and containers to provide your team with a consistent, secure, and zero-configuration development environment that interacts with your IBM Z platform.  
  
IBM Wazi Developer for Workspaces provides a modern experience for mainframe software developers working with z/OS applications in the cloud. Powered by the open-source projects Zowe and Red Hat CodeReady Workspaces, IBM Wazi Developer for Workspaces offers an easy, streamlined on-boarding process to provide mainframe developers the tools they need. Using container technology and stacks, IBM Wazi Developer for Workspaces brings the necessary technology to the task at hand.
  
---
  
**_Red Hat Content_**  
 
# What's inside?

This repository hosts CodeReady Workspaces assembly that mainly inherits Eclipse Che artifacts and repackages some of them:

Differences as compared to upstream:

* Customized Dashboard (pics, icons, titles, loaders, links)
* Samples and Stacks modules
* Bayesian Language Server and agent
* Product Info plugin (IDE customizations: pics, titles links)
* Custom Dockerfile based on official RH OpenJDK image from RHCC
  
| | |
|-|-|
| NOTE | Dockerfiles in this repo are NOT the ones used to build RHCC container images in OSBS. |

## How to Build

### Pre-reqs

JDK 1.8+
Maven 3.5+

### Build Assembly

Run the following command in the root of a repository:

```
mvn clean install
```

The build artifact used in the Docker image will be in `assembly/assembly-main/target/codeready-${version}/codeready-${version}`


### How to Build Container Image Locally

First, build the CRW assembly in this repo:

```
mvn clean install
```

Then just use the `Dockerfile` in this repo to build:

```
docker build --force-rm -t registry.redhat.io/codeready-workspaces/server-rhel8:1.2 . && \
docker images | grep registry.redhat.io/codeready-workspaces/server-rhel8:1.2
```

You can then reference this image in your deployment (set image pull policy to *`Always`* to make sure it's pulled instead of the default one).

For more info on how to test locally built changes in a local OKD 3.11 (Minishift 1.34) cluster, see [Build CodeReady Workspaces server container locally and deploy using Minishift](devdoc/building/building-crw.adoc#make-changes-to-crw-and-re-deploy-to-minishift).

| | |
|-|-|
| NOTE | Stacks may reference non-existing images like `docker-registry.default.svc:5000/openshift/rhel-base-jdk8`. These images are built as a post installation step.<br><br>Once published, they will be in locations like these:<br><br>* registry.redhat.io/codeready-workspaces/server-rhel8:1.2<br>* registry.redhat.io/codeready-workspaces/server-operator-rhel8:1.2<br>* registry.redhat.io/codeready-workspaces/stacks-cpp-rhel8:1.2<br>* registry.redhat.io/codeready-workspaces/stacks-dotnet-rhel8:1.2<br>* registry.redhat.io/codeready-workspaces/stacks-golang-rhel8:1.2<br>* registry.redhat.io/codeready-workspaces/stacks-java-rhel8:1.2<br>* registry.redhat.io/codeready-workspaces/stacks-node-rhel8:1.2<br>* registry.redhat.io/codeready-workspaces/stacks-php-rhel8:1.2<br>* registry.redhat.io/codeready-workspaces/stacks-python-rhel8:1.2<br>* registry.redhat.io/codeready-workspaces/stacks-node:1.2 |

### How to Build Container Using Jenkins and OSBS/Brew (REQUIRES VPN)

If you have access to Red Hat VPN, clone the pkgs.devel repo, then run the `get-sources-jenkins.sh` script to pull the latest dependency tarball into the local project, and trigger a Brew build.

```
kinit
git clone ssh://kerberos-username@pkgs.devel.redhat.com/containers/codeready-workspaces
cd codeready-workspaces
./get-sources-jenkins.sh
```

See also:

* http://pkgs.devel.redhat.com/cgit/containers/codeready-workspaces/tree/README.adoc?h=crw-1.2-rhel-8

See this document for more on how to use those build systems, in order to publish a container image to Red Hat Container Catalog:

* https://github.com/redhat-developer/codeready-workspaces-productization/blob/master/devdoc/building/osbs-container-builds.adoc

### Keeping in sync with upstream

The Dockerfile and entrypoint.sh scripts in this repo are copied from [upstream repo](http://pkgs.devel.redhat.com/cgit/containers/codeready-workspaces/tree/?h=crw-1.2-rhel-8) into this one using a [Jenkins job](https://codeready-workspaces-jenkins.rhev-ci-vms.eng.rdu2.redhat.com/view/CRW_CI/view/Releng/job/crw_sync-pkgs.devel-to-github/) which adjusts it so it will work locally.

Upstream: http://pkgs.devel.redhat.com/cgit/containers/codeready-workspaces/tree/?h=crw-1.2-rhel-8

Job: https://codeready-workspaces-jenkins.rhev-ci-vms.eng.rdu2.redhat.com/view/CRW_CI/view/Releng/job/crw_sync-pkgs.devel-to-github/

Therefore any changes to files in this repo which also exist in upstream will be overwritten. Instead, push your changes into the pkgs.devel repo, and run the job to merge them into this one.

## Branding

To reskin this assembly, you need to edit the following files:

* [assembly/codeready-workspaces-assembly-dashboard-war/src/main/webapp/assets/branding/branding-crw.css](assembly/codeready-workspaces-assembly-dashboard-war/src/main/webapp/assets/branding/branding-crw.css) - replacement for [Che default css](https://github.com/eclipse/che/blob/master/dashboard/src/assets/branding/branding.css), copied via [Jenkinsfile](https://github.com/redhat-developer/codeready-workspaces/blob/master/Jenkinsfile#L177-L183) during Pipeline build
* [assembly/codeready-workspaces-assembly-dashboard-war/src/main/webapp/assets/branding/product.json.template](assembly/codeready-workspaces-assembly-dashboard-war/src/main/webapp/assets/branding/product.json.template)
  * [assembly/codeready-workspaces-assembly-dashboard-war/src/main/webapp/assets/branding/CodeReady.ico](assembly/codeready-workspaces-assembly-dashboard-war/src/main/webapp/assets/branding/CodeReady.ico) - browser tab favicon
  * [assembly/codeready-workspaces-assembly-dashboard-war/src/main/webapp/assets/branding/CRW_wordmark-bold-white.svg](assembly/codeready-workspaces-assembly-dashboard-war/src/main/webapp/assets/branding/CRW_wordmark-bold-white.svg) - top left wordmark
  * [assembly/codeready-workspaces-assembly-dashboard-war/src/main/webapp/assets/branding/CodeReady_icon_dashboard_footer.svg](assembly/codeready-workspaces-assembly-dashboard-war/src/main/webapp/assets/branding/CodeReady_icon_dashboard_footer.svg) - bottom left icon
  * [assembly/codeready-workspaces-assembly-dashboard-war/src/main/webapp/assets/branding/CodeReady_icon_loader.svg](assembly/codeready-workspaces-assembly-dashboard-war/src/main/webapp/assets/branding/CodeReady_icon_loader.svg) - dashboard loading animation

See also SVG assets in [product/branding/](product/branding/) folder.

| | |
|-|-|
| NOTE | When saving files in Inkscape, make sure you export as *Plain SVG*, then edit the resulting .svg file to remove any `<metadata>...</metadata>` tags and all their contents. You can also remove the `xmlns:rdf` definition. This will ensure they compile correctly. |
