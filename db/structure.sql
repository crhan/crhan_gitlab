CREATE TABLE "keys" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "key" text, "title" varchar(255), "identifier" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "projects" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "path" varchar(255), "description" text, "owner_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "user_projects" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "project_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "project_access" integer DEFAULT 0);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255) DEFAULT '' NOT NULL, "encrypted_password" varchar(255) DEFAULT '' NOT NULL, "reset_password_token" varchar(255), "reset_password_sent_at" datetime, "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar(255), "last_sign_in_ip" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "admin" boolean DEFAULT 'f' NOT NULL);
CREATE INDEX "index_keys_on_user_id" ON "keys" ("user_id");
CREATE INDEX "index_user_projects_on_project_id" ON "user_projects" ("project_id");
CREATE INDEX "index_user_projects_on_user_id" ON "user_projects" ("user_id");
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email");
CREATE UNIQUE INDEX "index_users_on_reset_password_token" ON "users" ("reset_password_token");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20120420140825');

INSERT INTO schema_migrations (version) VALUES ('20120420140945');

INSERT INTO schema_migrations (version) VALUES ('20120420141012');

INSERT INTO schema_migrations (version) VALUES ('20120420152759');

INSERT INTO schema_migrations (version) VALUES ('20120420154333');

INSERT INTO schema_migrations (version) VALUES ('20120421063446');