

##############################################

SELECT id FROM media_resources WHERE media_resources.id in (
  WITH RECURSIVE pair(p,c) as
  (
      SELECT parent_id as p, child_id as c FROM media_resource_arcs 
        WHERE parent_id = 1
    UNION
      SELECT pair.p as p, media_resource_arcs.child_id as c from pair, media_resource_arcs
        WHERE media_resource_arcs.parent_id = c
        
  ) select c from pair
) order by id; 

##############################################

SELECT DISTINCT ON  meta_key_definitions.meta_context_id
  meta_key_definitions.meta_context_id, meta_data.id as meta_data_id, meta_data.string , meta_keys.* 
  FROM meta_data,meta_keys,meta_key_definitions 
  WHERE  true
  AND meta_key_definitions.meta_key_id = meta_keys.id 
  AND  meta_data.meta_key_id = meta_keys.id 
  AND type = 'MetaDatumString' 
  AND string like '%Binary%'
  ;


SELECT 
  meta_key_definitions.meta_context_id, meta_data.id as meta_data_id, meta_data.string , meta_keys.* 
  FROM meta_data,meta_keys,meta_key_definitions 
  WHERE  true
  AND meta_key_definitions.meta_key_id = meta_keys.id 
  AND  meta_data.meta_key_id = meta_keys.id 
  AND type <> 'MetaDatumString' 
  AND string like '%Binary%'
  ;




SELECT 
    keywords.id as keyword_id,
    meta_data.id as meta_data_id, 
    meta_keys.meta_datum_object_type as object_type
  FROM meta_data
  INNER JOIN meta_data_keywords ON meta_data_keywords.meta_datum_id = meta_data.id
  INNER JOIN keywords ON keywords.id = meta_data_keywords.keyword_id
  INNER JOIN meta_keys ON  meta_data.meta_key_id = meta_keys.id
  WHERE true
  AND meta_keys.meta_datum_object_type = 'MetaDatumKeywords';

--

SELECT keywords.id, count(meta_data.id) as count_meta_data_id
  FROM meta_data
  INNER JOIN meta_data_keywords ON meta_data_keywords.meta_datum_id = meta_data.id
  INNER JOIN keywords ON keywords.id = meta_data_keywords.keyword_id
  INNER JOIN meta_keys ON  meta_data.meta_key_id = meta_keys.id
  WHERE true
  AND meta_keys.meta_datum_object_type = 'MetaDatumKeywords'
  GROUP BY keywords.id 
  ORDER BY count_meta_data_id DESC
  ;

SELECT meta_data.id as meta_datum_id, count(keywords.id) as count_keyword_id
  FROM meta_data
  INNER JOIN meta_data_keywords ON meta_data_keywords.meta_datum_id = meta_data.id
  INNER JOIN keywords ON keywords.id = meta_data_keywords.keyword_id
  INNER JOIN meta_keys ON  meta_data.meta_key_id = meta_keys.id
  WHERE true
  AND meta_keys.meta_datum_object_type = 'MetaDatumKeywords'
  GROUP BY meta_data.id
  ORDER BY count_keyword_id DESC
  ;


SELECT keyword_id, count(meta_datum_id) as meta_datum_id_count
  FROM meta_data_keywords
  GROUP BY keyword_id
  ORDER BY meta_datum_id_count DESC
  ;


SELECT meta_datum_id, count(keyword_id) as keyword_id_count
  FROM meta_data_keywords
  GROUP BY meta_datum_id
  ORDER BY keyword_id_count DESC
  ;



-- 


SELECT meta_data.value, meta_keys.object_type FROM meta_data, meta_keys
  WHERE true
  AND meta_data.meta_key_id = meta_keys.id
  AND meta_keys.object_type = 'MetaDepartment'
  AND meta_data.value LIKE '%87%';
  

select * from meta_data 
where true
AND meta_data.media_resource_id = 27
;

--

SELECT `media_resources`.* FROM `media_resources`  WHERE (id in ((( SELECT NULL) 
      UNION ( ( SELECT media_resources.id as media_resource_id FROM `grouppermissions` INNER JOIN `groups` ON `groups`.`id` = `grouppermissions`.`group_id` INNER JOIN `groups_users` ON `groups_users`.`group_id` = `groups`.`id` INNER JOIN `users` ON `users`.`id` = `groups_users`.`user_id` INNER JOIN `media_resources` ON `media_resources`.`id` = `grouppermissions`.`media_resource_id` WHERE `grouppermissions`.`download` = 0 AND `grouppermissions`.`view` = 1 AND `grouppermissions`.`edit` = 0 AND `grouppermissions`.`manage` = 0 AND (users.id = 2) )
              )
            ) UNION (( SELECT NULL) 
            UNION ( SELECT media_resources.id as media_resource_id FROM `userpermissions` INNER JOIN `media_resources` ON `media_resources`.`id` = `userpermissions`.`media_resource_id` WHERE `userpermissions`.`download` = 0 AND `userpermissions`.`view` = 1 AND `userpermissions`.`edit` = 0 AND `userpermissions`.`manage` = 0 AND `userpermissions`.`user_id` = 2 ) 
          )));

SELECT `media_resources`.* FROM `media_resources`  WHERE (id in 
  (  SELECT media_resources.id as media_resource_id 
          FROM `grouppermissions` 
          INNER JOIN `groups` ON `groups`.`id` = `grouppermissions`.`group_id` INNER JOIN `groups_users` ON `groups_users`.`group_id` = `groups`.`id` 
          INNER JOIN `users` ON `users`.`id` = `groups_users`.`user_id` INNER JOIN `media_resources` ON `media_resources`.`id` = `grouppermissions`.`media_resource_id` 
          WHERE `grouppermissions`.`download` = 0 AND `grouppermissions`.`view` = 1 AND `grouppermissions`.`edit` = 0 AND `grouppermissions`.`manage` = 0 AND (users.id = 2) 
       UNION 
         SELECT media_resources.id as media_resource_id FROM `userpermissions` 
          INNER JOIN `media_resources` ON `media_resources`.`id` = `userpermissions`.`media_resource_id` 
          WHERE `userpermissions`.`download` = 0 AND `userpermissions`.`view` = 1 
          AND `userpermissions`.`edit` = 0 AND `userpermissions`.`manage` = 0 AND `userpermissions`.`user_id` = 2 )) ;


SELECT `media_resources`.* FROM `media_resources`  WHERE (id in ( 
      ( SELECT media_resources.id as media_resource_id FROM `userpermissions` 
        INNER JOIN `media_resources` ON `media_resources`.`id` = `userpermissions`.`media_resource_id` 
          WHERE `userpermissions`.`download` = 0 
          AND `userpermissions`.`view` = 1 
          AND `userpermissions`.`edit` = 0 
          AND `userpermissions`.`manage` = 0 
          AND `userpermissions`.`user_id` = 2 ) 
          )) ;

SELECT `media_resources`.* FROM `media_resources`  WHERE (id in ( 
      (SELECT NULL)
    UNION
      ( SELECT media_resources.id as media_resource_id FROM `userpermissions` 
        INNER JOIN `media_resources` ON `media_resources`.`id` = `userpermissions`.`media_resource_id` 
          WHERE `userpermissions`.`download` = 0 
          AND `userpermissions`.`view` = 1 
          AND `userpermissions`.`edit` = 0 
          AND `userpermissions`.`manage` = 0 
          AND `userpermissions`.`user_id` = 2 ) 
          ))
      ;


(SELECT Null) UNION (SELECT NULL);

SELECT `media_resources`.* FROM `media_resources`  WHERE (id in ((( SELECT NULL) ) UNION (( SELECT NULL) UNION 
      ( SELECT media_resources.id as media_resource_id FROM `userpermissions` 
        INNER JOIN `media_resources` ON `media_resources`.`id` = `userpermissions`.`media_resource_id` 
          WHERE `userpermissions`.`download` = 0 
          AND `userpermissions`.`view` = 1 
          AND `userpermissions`.`edit` = 0 
          AND `userpermissions`.`manage` = 0 
          AND `userpermissions`.`user_id` = 2 ) 
          )))
      ;


SELECT `media_resources`.* FROM `media_resources`  WHERE (id in (( SELECT NULL)) ) ;


-- filtering Betrachter and "Betrachter original" on prod for susanneschuhmacher

SELECT "media_resources".* FROM "media_resources"  WHERE ( media_resources.id in (  (( SELECT NULL) 
      UNION ((SELECT media_resources.id as media_resource_id FROM "grouppermissions" INNER JOIN "groups" ON "groups"."id" = "grouppermissions"."group_id" INNER JOIN "groups_users" ON "groups_users"."group_id" = "groups"."id" INNER JOIN "users" ON "users"."id" = "groups_users"."user_id" INNER JOIN "media_resources" ON "media_resources"."id" = "grouppermissions"."media_resource_id" WHERE "grouppermissions"."download" = 'f' AND "grouppermissions"."view" = 't' AND "grouppermissions"."edit" = 'f' AND "grouppermissions"."manage" = 'f' AND (users.id = 10301)) EXCEPT ((SELECT NULL)UNION (SELECT media_resources.id FROM "userpermissions" INNER JOIN "media_resources" ON "media_resources"."id" = "userpermissions"."media_resource_id" WHERE "userpermissions"."view" = 'f' AND "userpermissions"."user_id" = 10301)))UNION ((SELECT media_resources.id as media_resource_id FROM "grouppermissions" INNER JOIN "groups" ON "groups"."id" = "grouppermissions"."group_id" INNER JOIN "groups_users" ON "groups_users"."group_id" = "groups"."id" INNER JOIN "users" ON "users"."id" = "groups_users"."user_id" INNER JOIN "media_resources" ON "media_resources"."id" = "grouppermissions"."media_resource_id" WHERE "grouppermissions"."download" = 't' AND "grouppermissions"."view" = 't' AND "grouppermissions"."edit" = 'f' AND "grouppermissions"."manage" = 'f' AND (users.id = 10301)) EXCEPT ((SELECT NULL)UNION (SELECT media_resources.id FROM "userpermissions" INNER JOIN "media_resources" ON "media_resources"."id" = "userpermissions"."media_resource_id" WHERE "userpermissions"."download" = 'f' AND "userpermissions"."user_id" = 10301)UNION (SELECT media_resources.id FROM "userpermissions" INNER JOIN "media_resources" ON "media_resources"."id" = "userpermissions"."media_resource_id" WHERE "userpermissions"."view" = 'f' AND "userpermissions"."user_id" = 10301)))) UNION (( SELECT NULL) 
      UNION (SELECT media_resources.id as media_resource_id FROM "userpermissions" INNER JOIN "media_resources" ON "media_resources"."id" = "userpermissions"."media_resource_id" WHERE "userpermissions"."download" = 'f' AND "userpermissions"."view" = 't' AND "userpermissions"."edit" = 'f' AND "userpermissions"."manage" = 'f' AND "userpermissions"."user_id" = 10301) 
      UNION (SELECT media_resources.id as media_resource_id FROM "userpermissions" INNER JOIN "media_resources" ON "media_resources"."id" = "userpermissions"."media_resource_id" WHERE "userpermissions"."download" = 't' AND "userpermissions"."view" = 't' AND "userpermissions"."edit" = 'f' AND "userpermissions"."manage" = 'f' AND "userpermissions"."user_id" = 10301) 
    ) ))
;



-- permission check

SELECT DISTINCT m.* FROM `media_resources` AS m
  LEFT JOIN `userpermissions` AS up
    ON m.id = up.media_resource_id AND up.user_id = 999999 AND up.view = 1
  LEFT JOIN (`grouppermissions` AS gp
        INNER JOIN `groups_users` AS gu ON gp.group_id = gu.group_id AND gu.user_id = 999999
        LEFT JOIN `userpermissions` AS up2 ON gp.media_resource_id = up2.media_resource_id)
    ON m.id = gp.media_resource_id AND gp.view = 1
WHERE (up.id IS NOT NULL OR gp.id IS NOT NULL)
  AND (up2.view = 1 OR up2.view IS NULL); -- (up2.view != 0) doesn't work, alternative: (IFNULL(up2.view, -1) != 0) 


SELECT * 
  FROM "grouppermissions" INNER JOIN groups_users ON groups_users.group_id = grouppermissions.group_id 
  WHERE "grouppermissions"."view" = 't' 
  AND (groups_users.user_id = 1) 
  AND ( media_resource_id NOT IN ( SELECT media_resource_id FROM "userpermissions"  WHERE "userpermissions"."view" = 'f' AND "userpermissions"."user_id" = 1 )) 



SELECT users.id as user_id, people.lastname as lastname, people.firstname as firstname 
  FROM users, people
  WHERE true
  AND users.person_id = people.id
  AND users.id in
    (SELECT media_resources.user_id FROM "media_resources" LEFT JOIN full_texts ON media_resources.id = full_texts.media_resource_id WHERE "media_resources"."type" IN ('MediaEntry') AND ( media_resources.id IN  (
                SELECT media_resource_id FROM "userpermissions"  WHERE "userpermissions"."view" = 't' AND "userpermissions"."user_id" = 1 
            UNION
                SELECT media_resource_id FROM "grouppermissions" INNER JOIN groups_users ON groups_users.group_id = grouppermissions.group_id WHERE "grouppermissions"."view" = 't' AND (groups_users.user_id = 1) AND ( media_resource_id NOT IN ( SELECT media_resource_id FROM "userpermissions"  WHERE "userpermissions"."view" = 'f' AND "userpermissions"."user_id" = 1 )) 
            UNION
                SELECT media_resources.id FROM "media_resources"  WHERE (media_resources.user_id = 1 OR media_resources.view = 't')
                  )) AND (text ILIKE '%au%')
              )
              ;



SELECT users.id as user_id, people.lastname as lastname, people.firstname as firstname 
    FROM "users" 
    INNER JOIN "people" ON "people"."id" = "users"."person_id" 
    WHERE ( users.id in SELECT "media_resources".* FROM "media_resources" LEFT JOIN full_texts ON media_resources.id = full_texts.media_resource_id WHERE "media_resources"."type" IN ('MediaEntry') AND ( media_resources.id IN  (
            SELECT media_resource_id FROM "userpermissions"  WHERE "userpermissions"."view" = 't' AND "userpermissions"."user_id" = 1 
        UNION
            SELECT media_resource_id FROM "grouppermissions" INNER JOIN groups_users ON groups_users.group_id = grouppermissions.group_id WHERE "grouppermissions"."view" = 't' AND (groups_users.user_id = 1) AND ( media_resource_id NOT IN ( SELECT media_resource_id FROM "userpermissions"  WHERE "userpermissions"."view" = 'f' AND "userpermissions"."user_id" = 1 )) 
        UNION
            SELECT media_resources.id FROM "media_resources"  WHERE (media_resources.user_id = 1 OR media_resources.view = 't')
              )) AND (text ILIKE '%au%') )
          ;


-- metadata

SELECT meta_terms.*, meta_key_definitions.label_id as label_id
  FROM meta_terms, meta_key_definitions, meta_contexts
  WHERE true
  AND meta_key_definitions.meta_context_id = meta_contexts.id
  AND meta_key_definitions.label_id = meta_terms.id
  AND meta_context.name = 'core'
  ;

SELECT media_resources.id as media_resource_id 
     , meta_data.id as meta_datum_id 
     , meta_data.value as meta_datum_value
     , meta_keys.id as meta_key_id
     , meta_contexts.id as meta_context_id
     , meta_contexts.name as meta_contex_name
     , meta_key_definitions.id as meta_key_definition_id
     , meta_key_definitions.label_id as label_id
     , meta_terms.en_gb as meta_term_en
  FROM media_resources 
  INNER JOIN meta_data ON meta_data.media_resource_id = media_resources.id
  INNER JOIN meta_keys ON meta_data.meta_key_id = meta_keys.id
  INNER JOIN meta_key_definitions ON meta_key_definitions.meta_key_id = meta_keys.id
  INNER JOIN meta_contexts ON meta_key_definitions.meta_context_id = meta_contexts.id
  INNER JOIN meta_terms ON meta_key_definitions.label_id = meta_terms.id
  where true
  AND media_resources.id = 4
  ;

-- relative top level sets of the user with id = 999999 

SELECT * from media_resources
    WHERE type = 'MediaSet'
    AND user_id = 999999
    AND id NOT IN 
      (SELECT child_id FROM media_set_arcs 
          WHERE parent_id in
          (SELECT id from media_resources
            WHERE type = 'MediaSet'
            AND user_id = 999999)
          AND child_id in
          (SELECT id from media_resources
              WHERE type = 'MediaSet'
              AND user_id = 999999));

SELECT DISTINCT mr1.* FROM media_resources mr1
  LEFT JOIN media_set_arcs msa ON msa.child_id = mr1.id
  LEFT JOIN media_resources mr2 ON msa.parent_id = mr2.id AND mr2.user_id = mr1.user_id
WHERE mr1.type IN ('MediaSet') AND mr1.user_id = 999999 AND mr2.id IS NULL;

-- 

SELECT "users".* FROM "users" 
  INNER JOIN "groups_users" ON "groups_users"."user_id" = "users"."id" 
  INNER JOIN "groups" ON "groups"."id" = "groups_users"."group_id" 
  INNER JOIN "grouppermissions" ON "grouppermissions"."group_id" = "groups"."id" 
  INNER JOIN "media_resources" ON "media_resources"."id" = "grouppermissions"."media_resource_id" 
  WHERE "grouppermissions"."view" = 't'  
  NOT IN ( SELECT "users".* FROM "users" INNER JOIN "userpermissions" ON "userpermissions"."user_id" = "users"."id" INNER JOIN "media_resources" ON "media_resources"."id" = "userpermissions"."media_resource_id" WHERE "userpermissions"."view" = 't' AND "media_resources"."id" = 1 AND "userpermissions"."view" = 'f' )

SELECT "media_resources".* FROM "media_resources"  WHERE ( media_resources.id IN  (
         SELECT media_resource_id FROM "userpermissions"  WHERE "userpermissions"."view" = 't' AND (user_id = 1 ) 
        UNION
         SELECT media_resource_id FROM "grouppermissions" INNER JOIN "groups" ON "groups"."id" = "grouppermissions"."group_id" INNER JOIN groups_users ON groups_users.group_id = grouppermissions.group_id WHERE "grouppermissions"."view" = 't' AND (groups_users.user_id = 1) AND ( media_resource_id NOT IN ( SELECT media_resource_id FROM "userpermissions"  WHERE "userpermissions"."view" = 'f' AND (user_id = 1 ) )) 
              ))

 

SELECT media_resource_id FROM `userpermissions`  WHERE `userpermissions`.`view` = 1 AND (user_id = 2233 )
UNION
SELECT media_resource_id FROM `grouppermissions` INNER JOIN `groups` ON `groups`.`id` = `grouppermissions`.`group_id` INNER JOIN groups_users ON groups_users.group_id = grouppermissions.group_id WHERE `grouppermissions`.`view` = 1 AND (groups_users.user_id = 2233) AND ( media_resource_id NOT IN ( SELECT media_resource_id FROM `userpermissions`  WHERE `userpermissions`.`view` = 0 AND (user_id = 2233 ) ))


SELECT users from users
  INNER JOIN  manageable_media_resources_users ON manageable_media_resources_users.user_id = users.id
  INNER JOIN media_resources ON media_resources.id = manageable_media_resources_users.media_resource_id;


---

SELECT DISTINCT * FROM "media_resources" 
  INNER JOIN "media_set_arcs" ON "media_resources"."id" = "media_set_arcs"."parent_id" 
  INNER JOIN editable_media_resources_users ON media_resources.id = media_set_id 
  WHERE "media_resources"."type" IN ('MediaSet') AND "media_set_arcs"."child_id" = 2


SELECT "media_resources".* FROM "media_resources" 
  INNER JOIN "media_set_arcs" ON "media_set_arcs"."parent_id" = "media_resources"."id" 
  INNER JOIN viewable_media_sets_users ON media_resources.id = media_set_id
  WHERE "media_resources"."type" IN ('MediaSet') AND ( child_id = 2 ) 



SELECT media_resource_id as media_resource_id, user_id as user_id 
  FROM userpermissions 
  JOIN permissionsets ON permissionsets.id = userpermissions.permissionset_id
  WHERE permissionsets.view = true;


SELECT media_resource_id as media_resource_id, user_id as user_id 
  FROM grouppermissions
    JOIN permissionsets ON permissionsets.id = grouppermissions.permissionset_id
    JOIN groups_users ON groups_users.group_id = grouppermissions.group_id
  WHERE permissionsets.view = true; 

SELECT media_resource_id as media_resource_id, user_id as user_id 
        FROM userpermissions 
        JOIN permissionsets ON permissionsets.id = userpermissions.permissionset_id
        WHERE permissionsets.view = false);
       
-- combined: 

SELECT media_resource_id as media_resource_id, user_id as user_id 
  FROM grouppermissions
    JOIN permissionsets ON permissionsets.id = grouppermissions.permissionset_id
    JOIN groups_users ON groups_users.group_id = grouppermissions.group_id
  WHERE permissionsets.view = true 
    AND (media_resource_id, user_id) NOT IN  (
      SELECT media_resource_id as media_resource_id, user_id as user_id 
        FROM userpermissions 
        JOIN permissionsets ON permissionsets.id = userpermissions.permissionset_id
        WHERE permissionsets.view = false);
       
SELECT media_resources.id as media_resource_id, users.id as user_id 
  FROM media_resources
  INNER JOIN permissionsets ON permissionsets.id = media_resources.permissionset_id
  CROSS JOIN users
  WHERE permissionsets.view = true;
  

  SELECT #{table_name}.id as #{ref_id model}, #{action}able_media_resources_users.user_id as user_id 
  FROM #{table_name}
  INNER JOIN #{action}able_media_resources_users 
  ON #{action}able_media_resources_users.media_resource_id = #{table_name}.media_resource_id;





SELECT "userpermissions".* FROM "userpermissions" 
  INNER JOIN "users" ON "users"."id" = "userpermissions"."user_id" 
  INNER JOIN "permissionsets" ON "permissionsets"."id" = "userpermissions"."permissionset_id" 
  INNER JOIN "media_resources" ON "media_resources"."id" = "userpermissions"."media_resource_id" 
  WHERE "userpermissions"."user_id" = 1 
  AND "userpermissions"."media_resource_id" = 1 
  AND (permissionsets.view = false) 
  LIMIT 1

-- migrating owner data

ALTER TABLE media_entries ADD COLUMN owner_id integer;
UPDATE media_entries 
SET owner_id = (SELECT upload_sessions.user_id as user_id
  FROM upload_sessions
  INNER JOIN  media_entries as me ON  upload_sessions.id = me.upload_session_id
                WHERE media_entries.id = me.id);



---

CREATE OR REPLACE FUNCTION del_SOURCETABLE_TARGETTABLE_referenced_fkey_KEYROW() 
RETURNS trigger
AS $$
DECLARE
BEGIN
  PERFORM DELETE FROM TARGETTABLE WHERE id = OLD.KEYROW;
  RETURN OLD;
END $$
LANGUAGE PLPGSQL;

CREATE TRIGGER del_SOURCETABLE_TARGETTABLE_referenced_fkey_KEYROW
  AFTER DELETE
  ON SOURCETABLE
  FOR EACH ROW execute procedure del_SOURCETABLE_TARGETTABLE_referenced_fkey_KEYROW();



CREATE OR REPLACE FUNCTION update_v_m_u_sanspublic_on_mediaresource_owner_update() 
RETURNS trigger
AS $$
DECLARE
BEGIN
  IF NEW.owner_id <> OLD.owner_id THEN
    IF NOT can_view_by_group_or_user_perm(OLD.id, OLD.owner_id) THEN
      PERFORM v_m_u_sanspublic_delete_if_exists(OLD.id, OLD.owner_id);
    END IF;
    PERFORM v_m_u_sanspublic_insert_if_not_exists(NEW.id,NEW.owner_id);
  END IF;
  RETURN NEW;
END $$
LANGUAGE PLPGSQL;


CREATE FUNCTION delref_fkey_userperm2ba04ffd52973efb154726d2ed4bdc7973eec9f4() 
RETURNS trigger
AS $$
DECLARE
BEGIN
  PERFORM DELETE FROM userpermissions WHERE id = OLD.userpermission_id;
  RETURN OLD;
END $$
LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION delref_fkey_userperm2ba04ffd52973efb154726d2ed4bdc7973eec9f4() 
RETURNS trigger
AS $$
DECLARE
BEGIN
  PERFORM DELETE FROM userpermissions WHERE id = OLD.userpermission_id;
  RETURN OLD;
END $$
LANGUAGE PLPGSQL;

--

CREATE VIEW viewable_mediasets_by_userpermission AS
  SELECT media_sets.id as media_set_id, users.id as user_id
    FROM media_sets
    INNER JOIN mediaset_userpermission_joins ON mediaset_userpermission_joins.media_set_id = media_sets.id
    INNER JOIN userpermissions ON userpermissions.id = mediaset_userpermission_joins.userpermission_id
    INNER JOIN users ON users.id = userpermissions.user_id
    WHERE userpermissions.may_view = true;


  
  
SELECT media_sets.id as media_set_id
  FROM media_sets;
  INNER JOIN mediaset_userpermission_joins ON mediaset_userpermission_joins.media_set_id = media_sets.id
  INNER JOIN userpermissions ON userpermissions.id = mediaset_userpermission_joins.userpermission_id
  INNER JOIN users ON users.id = userpermissions.user_id
  WHERE userpermissions.may_view = true;
  




