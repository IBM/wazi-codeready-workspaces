/*
 * Copyright (c) 2019-2020 Red Hat, Inc.
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 *   Red Hat, Inc. - initial API and implementation
 */
package com.redhat.codeready.selenium.dashboard;

import static org.eclipse.che.selenium.pageobject.dashboard.workspaces.WorkspaceDetails.StateWorkspace.RUNNING;
import static org.eclipse.che.selenium.pageobject.dashboard.workspaces.WorkspaceDetails.StateWorkspace.STOPPED;
import static org.eclipse.che.selenium.pageobject.dashboard.workspaces.WorkspaceDetails.WorkspaceDetailsTab.OVERVIEW;

import com.google.inject.Inject;
import com.redhat.codeready.selenium.pageobject.dashboard.CodereadyCreateWorkspaceHelper;
import com.redhat.codeready.selenium.pageobject.dashboard.CodereadyDashboard;
import org.eclipse.che.selenium.core.client.TestWorkspaceServiceClient;
import org.eclipse.che.selenium.core.user.DefaultTestUser;
import org.eclipse.che.selenium.pageobject.dashboard.NewWorkspace.Devfile;
import org.eclipse.che.selenium.pageobject.dashboard.workspaces.WorkspaceDetails;
import org.eclipse.che.selenium.pageobject.dashboard.workspaces.WorkspaceOverview;
import org.eclipse.che.selenium.pageobject.dashboard.workspaces.Workspaces;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

/** @author Andrey Chizhikov */
public class DeleteStoppingWorkspaceTest {

  @Inject private CodereadyDashboard dashboard;
  @Inject private WorkspaceDetails workspaceDetails;
  @Inject private Workspaces workspaces;
  @Inject private WorkspaceOverview workspaceOverview;
  @Inject private DefaultTestUser defaultTestUser;
  @Inject private CodereadyCreateWorkspaceHelper codereadyCreateWorkspaceHelper;
  @Inject private TestWorkspaceServiceClient workspaceServiceClient;

  private String workspaceName;

  @BeforeClass
  public void setUp() throws Exception {
    dashboard.open();
    workspaceName =
        codereadyCreateWorkspaceHelper.createAndStartWorkspace(
            Devfile.JAVA_MAVEN, "vertx-health-checks");
  }

  @AfterClass
  public void tearDown() throws Exception {
    workspaceServiceClient.delete(workspaceName, defaultTestUser.getName());
  }

  @Test
  public void deleteStoppingWorkspaceTest() {
    dashboard.open();

    dashboard.selectWorkspacesItemOnDashboard();
    dashboard.waitToolbarTitleName("Workspaces");
    workspaces.selectWorkspaceItemName(workspaceName);
    workspaceDetails.waitToolbarTitleName(workspaceName);
    workspaceDetails.selectTabInWorkspaceMenu(OVERVIEW);
    workspaceDetails.checkStateOfWorkspace(RUNNING);
    workspaceDetails.clickOnStopWorkspace();
    workspaceDetails.checkStateOfWorkspace(STOPPED);
    workspaceOverview.clickOnDeleteWorkspace();
    workspaceDetails.confirmWorkspaceDeletion();
    workspaceDetails.clickOnDeleteButtonInDialogWindow();
    workspaces.waitWorkspaceIsNotPresent(workspaceName);
    dashboard.waitToolbarTitleName("Workspaces");
  }
}
