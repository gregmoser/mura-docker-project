 <!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfinclude template="js.cfm">
<cfhtmlhead text="#session.dateKey#">
<cfset rsList=application.dashboardManager.getTopContent(rc.siteID,rc.limit,rc.membersOnly,rc.visitorStatus,rc.startDate,rc.stopDate) />
<cfset rsTotal=application.dashboardManager.getTotalHits(rc.siteID,rc.membersOnly,rc.visitorStatus,rc.startDate,rc.stopDate) />
<cfset items=rc.$.getBean('contentIterator')>
<cfset items.setQuery(rslist)>
<cfoutput>

<div class="mura-header">
<h1>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.topviewedcontent")#</h1>

	<cfinclude template="dsp_secondary_menu.cfm">

</div> <!-- /.mura-header -->

<div class="block block-constrain">
	<div class="block block-bordered">
	  <div class="block-content">

			<h3 class="alt">#application.rbFactory.getKeyValue(session.rb,"params.daterange")#</h3>
			<form novalidate="novalidate" name="searchFrm" onsubmit="return validate(this);" id="advancedSearch">
				<div class="mura-control-group">
					<label class="label-inline">
						#application.rbFactory.getKeyValue(session.rb,"params.from")#
						<input type="text" class="datepicker" name="startDate" value="#LSDateFormat(rc.startDate,session.dateKeyFormat)#" validate="date" message="The 'From' date is required." />
						#application.rbFactory.getKeyValue(session.rb,"params.to")#
						<input type="text" class="datepicker" name="stopDate" value="#LSDateFormat(rc.stopDate,session.dateKeyFormat)#" validate="date" message="The 'To' date is required." />
					#application.rbFactory.getKeyValue(session.rb,"params.numberofitems")#
	      	<select name="limit">
						<cfloop list="10,20,30,40,50,75,100" index="i">
						<option value="#i#" <cfif rc.limit eq i>selected</cfif>>#i#</option>
						</cfloop>
						</select>
					</label>
				</div>
			<div class="mura-actions">
				<div class="form-actions">
					<button class="btn mura-primary" onclick="submitForm(document.forms.searchFrm);"><i class="mi-search"></i>#application.rbFactory.getKeyValue(session.rb,"params.search")#</button></dd>
				</div>
			</div>

			<input type="hidden" value="#esapiEncode('html_attr',rc.siteid)#" name="siteID"/>
			<input type="hidden" value="cDashboard.topContent" name="muraAction"/>
			</form>

			<h3 class="alt">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.totalviews")#: <strong>#rstotal.hits#</strong></h3>

			<table class="mura-table-grid">
			<tr>
				<th class="actions"></th>
				<th class="var-width">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.content")#</th>
				<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.views")#</th>
				<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.percent")#</th>
			</tr>
			<cfif items.hasNext()>
			<cfloop condition="items.hasNext()">
			<cfsilent>
			<cfset item=items.next()>
			</cfsilent>
			<tr>
				<td class="actions">
					<a class="show-actions" href="javascript:;" <!---ontouchstart="this.onclick();"---> onclick="showTableControls(this);"><i class="mi-ellipsis-v"></i></a>
					<div class="actions-menu hide">	
						<ul class="actions-list">		
							<li class="preview"><a href="##" onclick="return preview('#item.getURL(complete=1)#');"><i class="mi-globe"></i>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#</a>
							</li>
						</ul>
					</div>		
				</td>
				<td class="var-width">#$.dspZoom(item.getCrumbArray())#</td>
				<td>#item.gethits()#</td>
				<td>#decimalFormat((item.gethits()/rstotal.hits)*100)#%</td>
			</tr>
			</cfloop>
			<cfelse>
			<tr>
			<td class="noResults" colspan="4">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.nosearchresults")#</td>
			</tr>
			</cfif>
			</table>
		</div> <!-- /.block-content -->
	</div> <!-- /.block-bordered -->
</div> <!-- /.block-constrain -->					

</cfoutput>