<script type="text/javascript">
	var breadcrumbs = [
		{icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm'},
		{
			label: "${ ui.message("openhmis.inventory.page")}",
			link: '${ui.pageLink("openhmis.inventory", "inventoryLanding")}'
		},
		{
			label: "${ ui.message("openhmis.inventory.manage.module")}",
			link: '/' + OPENMRS_CONTEXT_PATH + '/openhmis.inventory/inventory/manageModule.page'
		},
		{
			label: "${ ui.message("openhmis.inventory.admin.stockrooms")}",
			link: '/' + OPENMRS_CONTEXT_PATH + '/openhmis.inventory/stockroom/entities.page#/'
		},
		{label: "${ ui.message("openhmis.inventory.general.edit")} ${ui.message("openhmis.inventory.stockroom.name")}"}
	];

	jQuery('#breadcrumbs').html(emr.generateBreadcrumbHtml(breadcrumbs));

	jQuery(".tabs").tabs();

</script>

${ui.includeFragment("openhmis.commons", "editEntityHeaderFragment")}

<input type="hidden" ng-model="entity.uuid"/>

<div class="detail-section-border-bottom">
	<form class="entity-form" ng-class="{'submitted': submitted}">
		<ul class="table-layout">
			<li class="required">
				<span>{{messageLabels['general.name']}}</span>
			</li>
			<li>
				<input type="text" ng-model="entity.name" style="min-width: 50%;"
				       placeholder="{{messageLabels['general.name']}}" required/>
			</li>
		</ul>
		<ul class="table-layout">
			<li class="not-required">
				<span>{{messageLabels['openhmis.inventory.location.name']}}</span>
			</li>
			<li>
				<select ng-model="entity.location"
				        ng-options='location.display for location in locations track by location.uuid'>
				</select>
			</li>
		</ul>
		<br/>

		<div class="detail-section-border-top" ng-hide="entity.uuid !== ''">
			<br/>

			<p>
				<span><input type="button" class="cancel" value="{{messageLabels['general.cancel']}}" ng-click="cancel()"/>
				</span>
				<span><input type="button" class="confirm right" value="{{messageLabels['general.save']}}"
				             ng-click="saveOrUpdate()"/></span>
			</p>
		</div>
	</form>
</div>
<br/><br/>

<div class="tabs" ng-hide="entity.uuid === ''">
	<ul>
		<li ng-hide="entity.uuid === ''">
			<a href="#items">{{messageLabels['openhmis.inventory.item.namePlural']}}</a>
		</li>
		<li ng-hide="entity.uuid === ''">
			<a href="#operations">{{messageLabels['openhmis.inventory.operations.namePlural']}}</a>
		</li>
		<li ng-hide="entity.uuid === ''">
			<a href="#transactions">{{messageLabels['openhmis.inventory.stockroom.transactions']}}</a>
		</li>
	</ul>

	<div id="items" style="border: 0px;">
		<!-- search items -->
		${ ui.includeFragment("openhmis.commons", "searchFragment", [
				model: "searchItemStockName",
				onChangeEvent: "searchItemStock(entity.uuid)",
				class: ["field-display ui-autocomplete-input form-control searchinput"],
				placeholder: [ui.message("openhmis.inventory.general.enterSearchPhrase")]
		])}
		<br /><br />
		<table style="margin-bottom:5px;" class="manage-entities-table manage-stockrooms-table">
			<thead>
			<tr>
				<th>{{messageLabels['openhmis.inventory.item.name']}}</th>
				<th>{{messageLabels['openhmis.inventory.item.quantity']}}</th>
			</tr>
			</thead>
			<tbody>
			<tr class="clickable-tr" pagination-id="__items" dir-paginate="item in items | itemsPerPage: itemLimit"
			    total-items="itemTotalNumberOfResults" current-page="itemCurrentPage">
				<td ng-click="showItemDetails({item: item})">{{item.item.name}}</td>
				<td>{{item.quantity}}</td>
			</tr>
			</tbody>
		</table>

		<div ng-show="items.length == 0 && searchItemStockName != ''">
			${ui.message('Your search - <b>')} {{searchItemStockName}} ${ui.message('</b> - did not match any items')}
		</div>

		<div class="not-found" ng-show="items.length == 0 && searchItemStockName == ''">
			${ui.message('No items found')}
		</div>
		${ui.includeFragment("openhmis.commons", "paginationFragment", [
				hide                : "items.length == 0",
				paginationId        : "__items",
				onPageChange        : "searchItemStock(entity.uuid, itemCurrentPage)",
				model               : "itemLimit",
				onChange            : "searchItemStock(entity.uuid)",
				pagingFrom          : "itemPagingFrom(itemCurrentPage, itemLimit)",
				pagingTo            : "itemPagingTo(itemCurrentPage, itemLimit, itemTotalNumberOfResults)",
				totalNumberOfResults: "itemTotalNumberOfResults",
				showRetiredSection  : "false"
		])}
		<div id="item-details-dialog" class="dialog" style="display: none;">
			<div class="dialog-header">
				<span>
					<i class="icon-info-sign"></i>

					<h3>{{showItemDetailsTitle}}</h3>
				</span>
			</div>
			<div class="dialog-content form">
				<table>
					<thead>
					<tr>
						<th>{{messageLabels['openhmis.inventory.stockroom.batchOperation']}}</th>
						<th>{{messageLabels['openhmis.inventory.stockroom.expiration']}}</th>
						<th>{{messageLabels['openhmis.inventory.item.quantity']}}</th>
					</tr>
					</thead>
					<tr ng-repeat="item in itemDetails">
						<td>{{item.batchOperation.operationNumber}}</td>
						<td>{{item.expiration | date: 'dd-MM-yyyy'}}</td>
						<td>{{item.quantity}}</td>
					</tr>
				</table>
				<br/>

				<div class="ngdialog-buttons">
					<input style="float:right;" type="button" class="cancel" value="{{messageLabels['general.cancel']}}"
					       ng-click="closeThisDialog('Cancel')"/>
				</div>
			</div>
		</div>
	</div>

	<div id="operations" style="border: 0px;">

		<div style="width:500px;">
			<!-- search item stock operations -->
			${ ui.includeFragment("openhmis.commons", "searchFragment", [
					model: "searchItemStockOperationName",
					onChangeEvent: "searchOperationItems(searchItemStockOperationName)",
					class: ["form-control autocomplete-search"],
					placeholder: [ui.message("openhmis.inventory.general.enterSearchPhrase")],
					typeahead: ["item.name for item in autocompleteOperationItems"],
					typeaheadEditable: "true",
					typeaheadOnSelect: "selectOperationsItem(\$item)",
			])}
			<span>
				<input type="button" class="confirm right" value="Search"
				       ng-click="searchItemStockOperation(entity.uuid, itemStockOperationCurrentPage)" />
			</span>
		</div>
		<table style="margin-bottom:5px;" class="manage-entities-table manage-stockrooms-table">
			<thead>
			<tr>
				<th>{{messageLabels['openhmis.inventory.stockroom.dateCreated']}}</th>
				<th>{{messageLabels['openhmis.inventory.operations.type.name']}}</th>
				<th>{{messageLabels['openhmis.inventory.stockroom.operationNumber']}}</th>
				<th>{{messageLabels['openhmis.inventory.stockroom.status']}}</th>
			</tr>
			</thead>
			<tbody>
			<tr class="clickable-tr" pagination-id="__itemStockOperations"
			    dir-paginate="itemOperation in itemStockOperations | itemsPerPage: itemStockOperationLimit"
			    total-items="itemStockOperationTotalNumberOfResults" current-page="itemStockOperationCurrentPage">
				<td>{{itemOperation.dateCreated | date: 'dd-MM-yyyy, h:mma'}}</td>
				<td>{{itemOperation.instanceType.name}}</td>
				<td>{{itemOperation.operationNumber}}</td>
				<td>{{itemOperation.status}}</td>
			</tr>
			</tbody>
		</table>

		<div ng-show="itemStockOperations.length == 0 && searchItemStockOperationName != ''">
			${ui.message('Your search - <b>')} {{searchItemStockOperationName}} ${ui.message('</b> - did not match any items')}
		</div>

		<div class="not-found" ng-show="itemStockOperations.length == 0 && searchItemStockOperationName == ''">
			${ui.message('No Operations found')}
		</div>
		${ui.includeFragment("openhmis.commons", "paginationFragment", [
				hide                : "itemStockOperations.length == 0",
				paginationId        : "__itemStockOperations",
				onPageChange        : "searchItemStockOperation(entity.uuid, itemStockOperationCurrentPage)",
				model               : "itemStockOperationLimit",
				onChange            : "searchItemStockOperation(entity.uuid)",
				pagingFrom          : "itemPagingFrom(itemStockOperationCurrentPage, itemStockOperationLimit)",
				pagingTo            : "itemPagingTo(itemStockOperationCurrentPage, itemStockOperationLimit, itemStockOperationTotalNumberOfResults)",
				totalNumberOfResults: "itemStockOperationTotalNumberOfResults",
				showRetiredSection  : "false"
		])}
	</div>

	<div id="transactions" style="border: 0px;">
		<div style="width:500px;">
			<!-- search item stock transactions -->
			${ ui.includeFragment("openhmis.commons", "searchFragment", [
					model: "searchItemStockTransactionName",
					onChangeEvent: "searchTransactionItems(searchItemStockTransactionName)",
					class: ["form-control autocomplete-search"],
					placeholder: [ui.message("openhmis.inventory.general.enterSearchPhrase")],
					typeahead: ["item.name for item in autocompleteTransactionItems"],
					typeaheadEditable: "true",
					typeaheadOnSelect: "selectTransactionsItem(\$item)",
			])}
			<span>
				<input type="button" class="confirm right" value="Search"
				       ng-click="searchItemStockTransaction(entity.uuid, itemStockTransactionCurrentPage)" />
			</span>
		</div>
		<br />

		<table style="margin-bottom:5px;" class="manage-entities-table manage-stockrooms-table">
			<thead>
			<tr>
				<th>{{messageLabels['openhmis.inventory.stockroom.dateCreated']}}</th>
				<th>{{messageLabels['openhmis.inventory.operations.type.name']}}</th>
				<th>{{messageLabels['openhmis.inventory.item.name']}}</th>
				<th>{{messageLabels['openhmis.inventory.stockroom.batchOperation']}}</th>
				<th>{{messageLabels['openhmis.inventory.stockroom.expiration']}}</th>
				<th>{{messageLabels['openhmis.inventory.item.quantity']}}</th>
			</tr>
			</thead>
			<tbody>
			<tr class="clickable-tr" pagination-id="__itemStockTransactions"
			    dir-paginate="itemTransaction in itemStockTransactions | itemsPerPage: itemStockTransactionLimit"
			    total-items="itemStockTransactionTotalNumberOfResults" current-page="itemStockTransactionCurrentPage">
				<td>{{itemTransaction.dateCreated | date: 'dd-MM-yyyy, h:mma'}}</td>
				<td>{{itemTransaction.operation.operationNumber}}</td>
				<td>{{itemTransaction.item.name}}</td>
				<td>{{itemTransaction.batchOperation.operationNumber}}</td>
				<td>{{itemTransaction.expiration | date: 'dd-MM-yyyy'}}</td>
				<td>{{itemTransaction.quantity}}</td>
			</tr>
			</tbody>
		</table>

		<div ng-show="itemStockTransactions.length == 0 && searchItemStockTransactionName != ''">
			${ui.message('Your search - <b>')} {{searchItemStockTransactionName}} ${ui.message('</b> - did not match any items')}
		</div>

		<div class="not-found" ng-show="itemStockTransactions.length == 0 && searchItemStockTransactionName == ''">
			${ui.message('No Operation Transactions found')}
		</div>
		${ui.includeFragment("openhmis.commons", "paginationFragment", [
				hide                : "itemStockTransactions.length == 0",
				paginationId        : "__itemStockTransactions",
				onPageChange        : "searchItemStockTransaction(entity.uuid, itemStockTransactionCurrentPage)",
				model               : "itemStockTransactionLimit",
				onChange            : "searchItemStockTransaction(entity.uuid)",
				pagingFrom          : "itemPagingFrom(itemStockTransactionCurrentPage, itemStockTransactionLimit)",
				pagingTo            : "itemPagingTo(itemStockTransactionCurrentPage, itemStockTransactionLimit, itemStockTransactionTotalNumberOfResults)",
				totalNumberOfResults: "itemStockTransactionTotalNumberOfResults",
				showRetiredSection  : "false"
		])}
	</div>
</div>
<span ng-show="entity.uuid !== ''">
	<br/><br/><br/>

	<form>
		<div class="detail-section-border-top detail-section-border-bottom">
			<br/>

			<p>
				<span><input type="button" class="cancel" value="{{messageLabels['general.cancel']}}" ng-click="cancel()"/>
				</span>
				<span><input type="button" class="confirm right" value="{{messageLabels['general.save']}}"
				             ng-click="saveOrUpdate()"/></span>
			</p>
		</div>
		<br/><br/>
	</form>
</span>

${ui.includeFragment("openhmis.commons", "retireUnretireDeleteFragment")}
