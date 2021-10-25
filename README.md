[![Build Status](https://travis-ci.com/IBM/wazi-codeready-workspaces.svg?branch=main)](https://travis-ci.com/IBM/wazi-codeready-workspaces)
[![Release](https://img.shields.io/github/release/IBM/wazi-codeready-workspaces.svg)](../../releases/latest)
[![License](https://img.shields.io/github/license/IBM/wazi-codeready-workspaces)](LICENSE)
[![DockerHub](https://img.shields.io/badge/DockerHub-DevFile-blue?color=3498db)](https://hub.docker.com/repository/docker/ibmcom/wazi-code-dev-file)
[![DockerHub](https://img.shields.io/badge/DockerHub-Plugin-blue?color=3498db)](https://hub.docker.com/repository/docker/ibmcom/wazi-code-plugin)
[![Documentation](https://img.shields.io/badge/Documentation-blue?color=1f618d)](https://ibm.biz/wazi-crw-doc)
    
# IBM Wazi Developer for Workspaces

IBM Wazi Developer for Red Hat CodeReady Workspaces (IBM Wazi Developer for Workspaces), delivers cloud-native developer experience, enabling development and testing of IBM z/OS application components in containerized, z/OS sandbox environment on Red Hat OpenShift Container Platform running on x86 hardware, and providing capability to deploy applications into production on native z/OS running on IBM Z hardware. IBM Wazi Developer is a development environment that provides an in-browser IDE with a single-click developer workspace with the capabilities to code, edit, build, and debug.  
  
IBM Wazi Developer for Workspaces is built on the Red Hat CodeReady Workspaces project. The core functionality for Red Hat CodeReady Workspaces is provided by an open-source project called Eclipse Che. IBM Wazi Developer for Workspaces uses Kubernetes and containers to provide your team with a consistent, secure, and zero-configuration development environment that interacts with your IBM Z platform.  

- This repository is based off of the upstream [Red Hat CodeReady for Workspaces](https://github.com/redhat-developer/codeready-workspaces/tree/crw-2.10-rhel-8) (_crw-2.10-rhel-8_) , where the code is in other upstream repositories by the [Eclipse Foundation](https://github.com/eclipse/).
  
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
- Connectivity to Z host using [Zowe Explorer](https://github.com/IBM/zopeneditor-about)
- Connectivity to Z host using [IBM Remote System Explorer API](https://ibm.github.io/zopeneditor-about/Docs/introduction.html)
- Debugging COBOL and PL/I applications using [IBM Z Open Debug](https://github.com/IBM/zopendebug-about)
- Mainframe Development package with a custom plug-in and devfile registry support using the [IBM Wazi Developer stack](https://github.com/IBM/wazi-codeready-workspaces)

### Customizing the Registry Images
IBM Wazi Developer for Workspaces allows for additional custom devfile stack(s) and plugins for a tailored development environment. After the registry images are rebuilt and pushed into a container registry, then these images can be specified when creating an instance of IBM Wazi Developer for Workspaces or to patch an existing instance.

#### Custom Devfile Registry Image

**Working Directory:** ./dependencies/che-devfile-registry

1. Add a custom devfile stack into the [devfiles](dependencies/che-devfile-registry/devfiles) folder. See the [Wazi Developer](dependencies/che-devfile-registry/devfiles/01_wazi-developer) stack for an example and [Devfile specifications](https://devfile.io/docs).
1. Add an image into the [images folder](dependencies/che-devfile-registry/images).
1. Build the devfile registry image and push the image into a container registry accessible by the OpenShift cluster.

```
docker build -t <registry>/<namespace>/<devfile_image_name>:<tag> -f build/dockerfiles/Dockerfile --target "registry" .
docker push <registry>/<namespace>/<devfile_image_name>:<tag>
```

#### Custom Plugin Registry Image

**Working Directory:** ./dependencies/che-plugin-registry

1. Add a custom plugin into the [plugins](dependencies/che-plugin-registry/v3/plugins) folder. See the [Wazi Developer](dependencies/che-plugin-registry/v3/plugins/ibm) plugins for an example.
1. Add an image into the [images folder](dependencies/che-plugin-registry/v3/images).
1. Update the [index.json](dependencies/che-plugin-registry/v3/plugins/index.json) file with an entry for the custom plugin.
1. Download the Wazi Developer extensions per the table specifications below.
1. Build the plugin registry image and push the image into a container registry accessible by the OpenShift cluster.

```
docker build -t <registry>/<namespace>/<plugin_image_name>:<tag> -f build/dockerfiles/Dockerfile --target "registry" .
docker push <registry>/<namespace>/<plugin_image_name>:<tag>
```

| Source Download | Target Path | Target Filename |
| --- | :--- | :--- |
| [Z Open Editor](https://github.com/IBM/zopeneditor-about/releases) | v3/plugins/ibm/wazi-developer/latest/extensions | zopeneditor.vsix |
| [Z Open Editor](https://github.com/IBM/zopeneditor-about/releases) | v3/plugins/ibm/wazi-developer/latest/extensions | wazi-vscode-extension-for-zowe.vsix |
| [Z Open Debug](https://github.com/IBM/zopendebug-about/releases) | v3/plugins/ibm/wazi-debug/latest/extensions | zopendebug.vsix |
| [Z Open Debug](https://github.com/IBM/zopendebug-about/releases) | v3/plugins/ibm/wazi-debug/latest/extensions | zopendebug-profileui.vsix |

**Note:** If the `extensions` folder does not exist, then please create it and rename the extension files to match what is listed in the table.
  
---
  
**_Red Hat Content_**  
 
Links marked with this icon :door: are _internal to Red Hat_. This includes Jenkins servers, job configs in gitlab, and container sources in dist-git. 

Because these services are internal, in the interest of making all things open, we've copied as much as possible into the [codeready-workspaces-images](https://github.com/redhat-developer/codeready-workspaces-images) repo.

# What's inside?

**NOTE:** the so-called master branch is deprecated and is no longer kept up to date. Instead, the latest nightly sources are in **crw-2-rhel-8 branch**, synced to upstream projects' main (or master) branches.

For the latest stable release, see the **crw-2.y-rhel-8** branch with the largest y value.

---

This repository no longer hosts the CodeReady Workspaces Server assembly that mainly inherits Eclipse Che artifacts and repackages some of them. Server has moved to [codeready-workspaces-images/codeready-workspaces](https://github.com/redhat-developer/codeready-workspaces-images/blob/crw-2-rhel-8/codeready-workspaces/README.adoc#how-to-build-locally).

## How to Build

See this document for how to use those build systems, in order to publish a container image to Red Hat Container Catalog:

* https://github.com/redhat-developer/codeready-workspaces-productization/blob/master/devdoc/building/osbs-container-builds.adoc

See also:

* https://main-jenkins-csb-crwqe.apps.ocp4.prod.psi.redhat.com/job/CRW_CI/ (crw-server_*) :door:
* https://github.com/redhat-developer/codeready-workspaces-images#jenkins-jobs

### Keeping CRW dependencies in sync with upstream and downstream

Folders under [/dependencies](dependencies) are synced to https://github.com/redhat-developer/codeready-workspaces-images. If no matching project exists under the [/dependencies](dependencies) folder, sync occurs directly from an upstream Che project.

The sync logic is in one of three places:

* a Jenkins job - eg., [crw-theia-sources_2.x.jenkinsfile](https://github.com/redhat-developer/codeready-workspaces-images/blob/crw-2-rhel-8/crw-jenkins/jobs/CRW_CI/crw-theia-sources_2.x.jenkinsfile), 
* a get-sources-jenkins.sh script - eg., [plugin-java8 get-sources-jenkins.sh](https://github.com/redhat-developer/codeready-workspaces-images/blob/crw-2-rhel-8/codeready-workspaces-plugin-java8/get-sources-jenkins.sh), or
* a sync-*.sh script - eg., [devworkspace controller build/scripts/sync.sh](https://github.com/redhat-developer/codeready-workspaces-images/blob/crw-2-rhel-8/codeready-workspaces-devworkspace-controller/build/scripts/sync.sh). 

**NOTE:** over time we're trying to move all sync logic out of Jenkinsfiles and into scripts that can be run locally, so during outages build process can still be orchestrated. Goal is to have Jenkins simply call sync.sh scripts to perform syncs, and get-sources.sh scripts to collect assets from Jenkins (or other places) in order to commit those source tarballs + trigger Brew builds.

Sync jobs:

* https://main-jenkins-csb-crwqe.apps.ocp4.prod.psi.redhat.com/job/CRW_CI/ (jobs) :door:
* https://gitlab.cee.redhat.com/codeready-workspaces/crw-jenkins/-/tree/master/jobs/CRW_CI (sources) :door:
* https://github.com/redhat-developer/codeready-workspaces-images#jenkins-jobs (copied sources)

## Branding

Branding is currently in two places.

* To reskin [Che Dashboard](https://github.com/eclipse-che/che-dashboard), see [dashboard](https://github.com/redhat-developer/codeready-workspaces-images/tree/crw-2-rhel-8/codeready-workspaces-dashboard/README.adoc)

* To reskin [Che Theia](https://github.com/eclipse-che/che-theia), see [theia/conf/theia/branding](https://github.com/redhat-developer/codeready-workspaces-theia/tree/crw-2-rhel-8/conf/theia/branding)
