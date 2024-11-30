CREATE SCHEMA IF NOT EXISTS prod;
CREATE SCHEMA IF NOT EXISTS crm;

CREATE TABLE IF NOT EXISTS prod.roles (
  uuid UUID,
  role_name TEXT,

  PRIMARY KEY(uuid)
);

CREATE TABLE IF NOT EXISTS prod.employees (
    uuid UUID,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    role_uuid UUID REFERENCES prod.roles(uuid),

    PRIMARY KEY(uuid)
);

CREATE TABLE IF NOT EXISTS prod.regions (
    uuid UUID,
    region_name TEXT,
    region_lead UUID REFERENCES prod.employees(uuid),

    PRIMARY KEY(uuid)
);

CREATE TABLE IF NOT EXISTS prod.countries (
    uuid UUID,
    country_name TEXT,
    region_uuid UUID REFERENCES prod.regions(uuid),

    PRIMARY KEY(uuid)
);

CREATE TABLE IF NOT EXISTS crm.account_managers (
    id INT,
    first_name TEXT,
    last_name TEXT,
    email TEXT,

    PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS crm.accounts (
    id INT,
    account_name TEXT,
    account_value INTEGER,
    account_manager_id INT REFERENCES crm.account_managers(id),

    PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS prod.clients (
    uuid UUID,
    client_name TEXT,
    industry TEXT,
    crm_account_id INT REFERENCES crm.accounts(id),

    PRIMARY KEY(uuid)
);

CREATE TABLE IF NOT EXISTS prod.verification_sessions (
    uuid UUID,
    status TEXT,
    client_uuid UUID REFERENCES prod.clients(uuid),
    verification_specialist_uuid UUID REFERENCES prod.employees(uuid),

    PRIMARY KEY(uuid)
);

CREATE TABLE IF NOT EXISTS prod.documents (
    uuid UUID,
    type TEXT,
    verification_session_uuid UUID REFERENCES prod.verification_sessions(uuid),
    country_uuid UUID REFERENCES prod.countries(uuid),

    PRIMARY KEY(uuid)
);
