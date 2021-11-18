[![Build Status](https://travis-ci.com/IBM/wazi-codeready-workspaces.svg?branch=main)](https://travis-ci.com/IBM/wazi-codeready-workspaces)
[![Release](https://img.shields.io/github/release/IBM/wazi-codeready-workspaces.svg)](../../releases/latest)
[![License](https://img.shields.io/github/license/IBM/wazi-codeready-workspaces)](LICENSE)
[![DockerHub](https://img.shields.io/badge/DockerHub-DevFile-blue?color=3498db)](https://hub.docker.com/repository/docker/ibmcom/wazi-code-dev-file)
[![DockerHub](https://img.shields.io/badge/DockerHub-Plugin-blue?color=3498db)](https://hub.docker.com/repository/docker/ibmcom/wazi-code-plugin)
[![Documentation](https://img.shields.io/badge/Documentation-blue?color=1f618d)](https://ibm.biz/wazi-crw-doc)

# What's inside?

This repository contains the registry images for IBM Wazi Developer for Red Hat CodeReady Workspaces (IBM Wazi Developer for Workspaces). This repository is based off of the upstream [Red Hat CodeReady for Workspaces](https://github.com/redhat-developer/codeready-workspaces/tree/crw-2.10-rhel-8) (_crw-2.10-rhel-8_), where the code is in other upstream repositories by the [Eclipse Foundation](https://github.com/eclipse/). For instructions on using this repository to build the custom registry images, see the [Customizing Wazi Developer for Workspaces registry images](#customizing-wazi-developer-for-workspaces-registry-images) section.
  
## IBM Wazi Developer for Workspaces

IBM Wazi Developer for Workspaces is a component shipped with either IBM Wazi Developer for Red Hat CodeReady Workspaces (Wazi Developer for Workspaces) or IBM Developer for z/OS Enterprise Edition (IDzEE).

IBM Wazi Developer for Workspaces provides a modern experience for mainframe software developers working with z/OS applications in the cloud. Powered by the open source projects Zowe and Red Hat CodeReady Workspaces, IBM Wazi Developer for Workspaces offers an easy, streamlined onboarding process to provide mainframe developers the tools they need. Using container technology, IBM Wazi Developer for Workspaces brings the necessary tools to the task at hand.

For more benefits of IBM Wazi Developer for Workspaces, see the [IBM Wazi Developer product page](https://www.ibm.com/products/wazi-developer) or [IDzEE product page](https://www.ibm.com/products/developer-for-zos).

## Details

IBM Wazi Developer for Workspaces provides a custom stack with the all-in-one mainframe development package that enables mainframe developers to:

- Use a modern mainframe editor with rich language support for COBOL, JCL, Assembler (HLASM), and PL/I, which provides language-specific features such as syntax highlighting, outline view, declaration hovering, code completion, snippets, a preview of copybooks, copybook navigation, and basic refactoring using IBM Z Open Editor, a component of IBM Wazi Developer for VS Code
- Integrate with any flavor of Git source code management (SCM)
- Perform a user build with IBM Dependency Based Build for any flavor of Git
- Work with z/OS resources such as MVS, UNIX files, and JES jobs
- Connect to the Z host with z/OSMF or IBM Remote System Explorer (RSE) API, using Zowe Explorer plus IBM Z Open Editor for a graphical user interface and Zowe CLI plus the RSE API plug-in for Zowe CLI for command line access
- Debug COBOL and PL/I applications using IBM Z Open Debug
- Use a mainframe development package with a custom plug-in and devfile registry support from the [IBM Wazi Developer stack](https://github.com/IBM/wazi-codeready-workspaces)

## Documentation

For details of the features for IBM Wazi Developer for Workspaces, see its [official documentation](https://ibm.biz/wazi-crw-doc).

| Repository | Description |
| --- | --- |
| [IBM Wazi Developer for Workspaces](https://github.com/ibm/wazi-codeready-workspaces) |  The devfile and plug-in registries |
| [IBM Wazi Developer for Workspaces Sidecars](https://github.com/ibm/wazi-codeready-workspaces-sidecars) | Supporting resources for the Wazi Developer plug-ins |
| [IBM Wazi Developer for Workspaces Operator](https://github.com/ibm/wazi-codeready-workspaces-operator) | Deployment using the Operator Lifecycle Manager |

## Feedback
  
We would love to hear feedback from you about IBM Wazi Developer for Workspaces.  
File an issue or provide feedback here: [IBM Wazi Developer for Workspaces Issues](https://github.com/IBM/wazi-codeready-workspaces/issues)

---

## Customizing Wazi Developer for Workspaces registry images

You can use the custom devfile and plug-in registry images to tailor your development environment. After you rebuild the registry images with modifications, and push the images into a container registry, you can deploy these images when creating an instance of Wazi Developer for Workspaces or apply the images to an existing instance.

_Stacks_ or workspace definitions are pre-configured CodeReady Workspaces with a dedicated set of tools that cover different developer personas. For example, you can pre-configure a workbench for testers with only the tools needed for their purposes. You can add new stacks by customizing the Wazi Developer for Workspaces devfile and plug-in registry.

To customize the registry images, start by cloning https://github.com/IBM/wazi-codeready-workspaces, then follow these steps.

### 1. Create a custom devfile registry image

1. Add a custom devfile stack into the devfiles folder: `dependencies/che-devfile-registry/devfiles`. For more information about Devfile specifications, see [About devfiles](https://devfile.io/docs).
1. Add an icon image for the devfile stack into the images folder: `dependencies/che-devfile-registry/images`.
1. Run the following commands to build the devfile registry image and push the image into a container registry that is accessible by the OpenShift cluster. Replace the bracketed placeholders with your appropriate values.

    ```shell
    docker build -t <registry>/<namespace>/<devfile_image_name>:<tag> -f build/dockerfiles/Dockerfile --target "registry" .
    docker push <registry>/<namespace>/<devfile_image_name>:<tag>
    ```

### 2. Create a custom plug-in registry image

1. Add a custom plug-in into the plug-ins folder: `dependencies/che-plugin-registry/v3/plugins`.
1. Add an icon image into the images folder: `dependencies/che-plugin-registry/v3/images`.
1. Update the `index.json` file: `dependencies/che-plugin-registry/v3/plugins/index.json`, with an entry for the custom plug-in.
1. Download the Wazi Developer extensions using the following table:

    | Source Download | Target Path | Target Filename |
    | --- | :--- | :--- |
    | [Z Open Editor](https://github.com/IBM/zopeneditor-about/releases) | v3/plugins/ibm/wazi-developer/latest/extensions | zopeneditor.vsix |
    | [Z Open Editor](https://github.com/IBM/zopeneditor-about/releases) | v3/plugins/ibm/wazi-developer/latest/extensions | vscode-extension-for-zowe.vsix |
    | [Z Open Debug](https://github.com/IBM/zopendebug-about/releases) | v3/plugins/ibm/wazi-debug/latest/extensions | zopendebug.vsix |
    | [Z Open Debug](https://github.com/IBM/zopendebug-about/releases) | v3/plugins/ibm/wazi-debug/latest/extensions | zopendebug-profileui.vsix |

    **Note:** If the `extensions` folder does not exist, create it and rename the extension files to match what is listed in the table.

1. Run the following commands to build the plug-in registry image and to push the image into a container registry that is accessible by the OpenShift cluster. Replace the bracketed placeholders with your appropriate values.

    ```shell
    docker build -t <registry>/<namespace>/<plugin_image_name>:<tag> -f build/dockerfiles/Dockerfile --target "registry" .
    docker push <registry>/<namespace>/<plugin_image_name>:<tag>
    ```

### 3. Deploy the custom devfile and plug-in registry images

After you create an instance of Wazi Developer for Workspaces, you can deploy the devfile and plug-in through the OpenShift web console with these steps:

1. In the OpenShift Container Platform web console, click **Operators > Installed Operators**, and locate **IBM Wazi Developer for Workspaces**.
1. Click **Create Instance** to create a new instance. If you already have a running instance, you can patch and restart it.
1. Locate and expand the **Server** section.
   - To add the custom devfile, in the **Devfile Registry Image** item, enter the correct value for the image from your container registry.
   - To add the custom plug-in, in the **Plugin Registry Image** item, enter the correct value for the image from your container registry.
1. Click **Create**. A new instance will be created with all of the registry changes.

---

## Reference: Red Hat content

Links marked with this icon :door: are _internal to Red Hat_. This includes Jenkins servers, job configs in gitlab, and container sources in dist-git.

Because these services are internal, in the interest of making all things open, we've copied as much as possible into the [codeready-workspaces-images](https://github.com/redhat-developer/codeready-workspaces-images) repo.

### What's inside?

**NOTE:** the so-called `master` branch is deprecated and is no longer kept up to date. Instead, the latest nightly sources are in the branch **`crw-2-rhel-8`**, synced to upstream projects' main (or master) branches.

For the latest stable release, see the **`crw-2.y-rhel-8`** branch with the largest `y` value.

---

This repository no longer hosts the CodeReady Workspaces Server assembly that mainly inherits Eclipse Che artifacts and repackages some of them. The server has moved to [codeready-workspaces-images/codeready-workspaces](https://github.com/redhat-developer/codeready-workspaces-images/blob/crw-2-rhel-8/codeready-workspaces/README.adoc#how-to-build-locally).

### How to Build

See this document for how to use the build systems in order to publish a container image to Red Hat Container Catalog:

- https://github.com/redhat-developer/codeready-workspaces-productization/blob/master/devdoc/building/osbs-container-builds.adoc

See also:

- https://main-jenkins-csb-crwqe.apps.ocp4.prod.psi.redhat.com/job/CRW_CI/ (crw-server_*) :door:
- https://github.com/redhat-developer/codeready-workspaces-images#jenkins-jobs

#### Keeping CRW dependencies in sync with upstream and downstream

Folders under [/dependencies](dependencies) are synced to https://github.com/redhat-developer/codeready-workspaces-images. If no matching project exists under the [/dependencies](dependencies) folder, sync occurs directly from an upstream Che project.

The sync logic is in one of three places:

- A Jenkins job - eg., [crw-theia-sources_2.x.jenkinsfile](https://github.com/redhat-developer/codeready-workspaces-images/blob/crw-2-rhel-8/crw-jenkins/jobs/CRW_CI/crw-theia-sources_2.x.jenkinsfile), 
- A get-sources-jenkins.sh script - eg., [plugin-java8 get-sources-jenkins.sh](https://github.com/redhat-developer/codeready-workspaces-images/blob/crw-2-rhel-8/codeready-workspaces-plugin-java8/get-sources-jenkins.sh), or
- A sync-*.sh script - eg., [devworkspace controller build/scripts/sync.sh](https://github.com/redhat-developer/codeready-workspaces-images/blob/crw-2-rhel-8/codeready-workspaces-devworkspace-controller/build/scripts/sync.sh).

**NOTE:** Over time, we are trying to move all sync logic out of Jenkinsfiles and into scripts that can be run locally, so during outages build process can still be orchestrated. The goal is to have Jenkins simply call sync.sh scripts to perform syncs, and get-sources.sh scripts to collect assets from Jenkins (or other places) in order to commit those source tarballs + trigger Brew builds.

Sync jobs:

- https://main-jenkins-csb-crwqe.apps.ocp4.prod.psi.redhat.com/job/CRW_CI/ (jobs) :door:
- https://gitlab.cee.redhat.com/codeready-workspaces/crw-jenkins/-/tree/master/jobs/CRW_CI (sources) :door:
- https://github.com/redhat-developer/codeready-workspaces-images#jenkins-jobs (copied sources)

### Branding

Branding is currently in two places.

- To reskin [Che Dashboard](https://github.com/eclipse-che/che-dashboard), see [dashboard](https://github.com/redhat-developer/codeready-workspaces-images/tree/crw-2-rhel-8/codeready-workspaces-dashboard/README.adoc)

- To reskin [Che Theia](https://github.com/eclipse-che/che-theia), see [theia/conf/theia/branding](https://github.com/redhat-developer/codeready-workspaces-theia/tree/crw-2-rhel-8/conf/theia/branding)
