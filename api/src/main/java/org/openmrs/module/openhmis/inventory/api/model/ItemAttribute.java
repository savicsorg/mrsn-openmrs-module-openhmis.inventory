/*
 * The contents of this file are subject to the OpenMRS Public License
 * Version 2.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
 * the License for the specific language governing rights and
 * limitations under the License.
 *
 * Copyright (C) OpenHMIS.  All Rights Reserved.
 */
package org.openmrs.module.openhmis.inventory.api.model;

import org.openmrs.module.openhmis.commons.api.entity.model.BaseSimpleAttributeMetadata;

/**
 * A value for a user-defined {@link ItemAttributeType} that is stored on an {@link Item}.
 * @see org.openmrs.attribute.Attribute
 */
public class ItemAttribute extends BaseSimpleAttributeMetadata<Item, ItemAttributeType> {
	public static final long serialVersionUID = 1L;
}
