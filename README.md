# nova_m

A dbt project targeting Snowflake.

## Project structure

```
models/
  staging/
    nm_raw/
      _nm_raw__sources.yml      # source table declarations (DBT_LEARN_ILYA.NM_RAW)
```

- **staging**: 1:1 with a raw source table. Renaming/casting only, no joins or
  business logic. Materialized as `view`.
- **marts**: business-facing, modeled entities built on `ref()`s to staging
  models. Materialized as `table` (switch to `incremental` per-model as
  tables grow).

`nm_raw` is the real source (raw_channels, raw_properties, raw_room_types,
raw_maintenance, raw_reservations). Staging models (`stg_nm_raw__*.sql`) and
marts still need to be added on top of it — duplicate the pattern from an
existing source when you add another one.

## Local setup

dbt reads connection credentials from `~/.dbt/profiles.yml`, which is
**not** part of this repo (it holds secrets). Create it with:

```yaml
# ~/.dbt/profiles.yml
nova_m:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <your_account_locator>
      user: <your_username>
      password: "{{ env_var('DBT_SNOWFLAKE_PASSWORD') }}"   # or use `authenticator: externalbrowser` / key-pair auth
      role: <your_role>
      database: <your_dev_database>
      warehouse: <your_warehouse>
      schema: dbt_<your_username>
      threads: 4
```

Then:

```bash
pip install dbt-snowflake
dbt debug        # verify the connection
dbt deps         # install packages, once packages.yml has any
dbt seed         # load seeds/, if any
dbt run          # build models
dbt test         # run schema + data tests
dbt docs generate && dbt docs serve   # browse the lineage graph & docs
```

## Conventions used in this project

- Naming: `stg_<source>__<entity>` for staging, `<mart>__<entity>` or
  `dim_`/`fct_` prefixes for marts.
- Every model has a matching `_<group>__models.yml` (or `_sources.yml`) with
  a `description` and at least a `unique` + `not_null` test on its primary
  key column.
- `dbt_project.yml` sets folder-level materialization defaults so individual
  models rarely need a `{{ config(...) }}` block.
