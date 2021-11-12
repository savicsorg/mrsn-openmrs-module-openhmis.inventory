/*
 * The contents of this file are subject to the OpenMRS Public License
 * Version 2.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */
(function() {
curl(
	{
		baseUrl: openhmis.url.resources
	},
	[
		openhmis.url.backboneBase + 'js/lib/jquery',
		openhmis.url.backboneBase + 'js/lib/backbone',
		openhmis.url.inventoryBase + 'js/model/item',
	],
	function($, Backbone, openhmis) {
		Backbone.__sync = Backbone.sync
		Backbone.sync = function() {};
		var testBaseUrl = '/src/test/webapp/resources/js';
		curl(
			[
				'js!' + testBaseUrl + '/model/item.js',
				'js!' + testBaseUrl + '/view/editors.js',
				'js!' + testBaseUrl + '/view/item.js'
			],
			function() {
				$(function() {
					window.reporter = new jasmine.HtmlReporter(); jasmine.getEnv().addReporter(reporter);
					jasmine.getEnv().execute();
				});
			}
		);
	}
);
})();