# nova_m

A dbt project targeting Snowflake.

## Project structure

```
models/
  staging/
    nm_raw/
      _nm_raw__sources.yml       # source table declarations (DBT_LEARN_ILYA.NM_RAW)
    _staging__models.yml         # docs/tests for all staging models below
    stg_channels.sql
    stg_properties.sql
    stg_room_types.sql
    stg_maintenance.sql
    stg_reservations.sql
  intermediate/
    _intermediate__models.yml    # docs/tests for both models below
    int_reservation_nights.sql   # reservations exploded to one row per stay night
    int_property_capacity.sql    # daily available rooms per property x room type
  marts/                         # not yet built
```

- **staging**: 1:1 with a raw source table. Renaming/casting only, no joins or
  business logic. Materialized as `view`.
- **intermediate**: joins across staging models and/or resolves a different
  grain (e.g. exploding reservations onto a date spine). Not meant to be
  queried directly by BI tools. Materialized as `view`.
- **marts**: business-facing, modeled entities (`dim_`/`fct_` prefixes) built
  on `ref()`s to staging/intermediate models. Materialized as `table`
  (switch to `incremental` per-model as tables grow).

`nm_raw` is the real source (raw_channels, raw_properties, raw_room_types,
raw_maintenance, raw_reservations). Marts still need to be added on top of
the intermediate layer — see the project DAG for the planned `dim_property`,
`dim_date`, `fct_reservation_nights`, `fct_capacity_monthly`, and
`mart_cancellation`.

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
dbt deps         # install packages declared in packages.yml (dbt_utils, dbt_expectations)
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
