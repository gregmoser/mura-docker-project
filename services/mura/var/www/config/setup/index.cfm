﻿<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. ?See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. ?If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and
conditions of the GNU General Public License version 2 (?GPL?) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, ?the copyright holders of Mura CMS grant you permission
to combine Mura CMS ?with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the ?/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/admin/
/tasks/
/config/
/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 ?without this exception. ?You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<!--- Give Mura 5 minutes for setup script to run to prevent it timing out when server configuration request timeout is too small --->
<cfsetting requesttimeout="300">

<!-----------------------------------------------------------------------
  RenderSetup is checked here to prove we got here for a legitimate
  reason and we aren't accessing these files directly (and illegally).
  If renderSetup is not found or is false then do not render.


  /config/appcfc/onRequestStart_include.cfm
------------------------------------------------------------------------>
<cfif !structKeyExists( request, 'renderMuraSetup' ) OR !request.renderMuraSetup >
  <cfabort />
</cfif>


<!-----------------------------------------------------------------------
  - Read values from existing settings.ini.cfm file.
  - Param some form values.
------------------------------------------------------------------------>
<cfinclude template="inc/_defaults.cfm" />


<!-----------------------------------------------------------------------
  If the setup form was submitted, go ahead and try to process it
------------------------------------------------------------------------>
<cfif form.action eq 'doSetup'>
  <cfinclude template="inc/_udf.cfm" />
  <cfinclude template="inc/_process.cfm" />

</cfif>

<!-----------------------------------------------------------------------
  If we were able to process the setup form
  - Tell mura to refresh on next hit
  - Show a happy congrats screen
------------------------------------------------------------------------>
<cfif variables.setupProcessComplete>
  <cfset application.appAutoUpdated = true />
  <cfinclude template="inc/_wrapperStart.cfm" />
  <cfinclude template="inc/_done.cfm" />
  <cfinclude template="inc/_wrapperEnd.cfm" />
  <cfabort/>
</cfif>


<!-----------------------------------------------------------------------
  if we made it this far, they aren't setup and need to
  see the setup form.
------------------------------------------------------------------------>
<cfinclude template="inc/_wrapperStart.cfm" />
<cfinclude template="inc/_form.cfm" />
<cfinclude template="inc/_wrapperEnd.cfm" />
