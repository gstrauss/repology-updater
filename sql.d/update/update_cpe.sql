-- Copyright (C) 2020 Dmitry Marakasov <amdmi3@amdmi3.ru>
--
-- This file is part of repology
--
-- repology is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- repology is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with repology.  If not, see <http://www.gnu.org/licenses/>.

--------------------------------------------------------------------------------
-- @param partial=False
-- @param analyze=True
--------------------------------------------------------------------------------
{% set packages = 'incoming_packages' if partial else 'packages' %}

DELETE FROM project_cpe
{% if partial %}
WHERE effname IN (SELECT effname FROM changed_projects)
{% endif %}
;

INSERT INTO project_cpe (
	effname,
	cpe_vendor,
	cpe_product
)
SELECT DISTINCT
    effname,
    cpe_vendor,
	cpe_product
FROM {{ packages }}
WHERE cpe_vendor IS NOT NULL AND cpe_product IS NOT NULL;

{% if analyze %}
ANALYZE project_cpe;
{% endif %}
