# WindMil Lua assistant reference package

This is a local reference tool for a coding assistant writing Milsoft WindMil Lua. It bundles the supplied JSON catalogs and example model exports, plus a command that retrieves small, source-labeled records for a coding task. It does not call an LLM or WindMil.

## Quick start

Requires Python 3.9+ and no third-party packages.

```bash
python windmil_ref.py "getElementField" --kind function --exact --detail
python windmil_ref.py "Switch Status" --kind field --limit 6
python windmil_ref.py "selection set" --kind example --limit 5
python windmil_ref.py "Partner Identifier" --kind sld --json
```

For an agent, put `AGENTS.md` in its working context and let it run `windmil_ref.py` while developing scripts. Search first, read full records for selected APIs and examples, then write the Lua. Each result includes a source filename and JSON path. `--json` makes results easy to feed into another program.

## Contents

- `references/`: the original JSON catalogs for functions, fields, examples, cross references, objects, EQDB, and export formats.
- `examples/tutorial2.std` and `.mpt`: the user supplied transformer and consumer example model.
- `examples/Subdivision_Primary.std` and `.mpt`: the latest partial subdivision candidate, including explicit open switch pairs and sample transformer/consumer relationships. Import of this latest candidate has not been confirmed in WindMil.
- `AGENTS.md`: rules learned from the reference files and import comparison.

The example `.std` and `.mpt` files support model structure reasoning. Equipment definitions may require the matching local EQDB. In particular, the `.std` transformer records do not identify a 25 kVA equipment choice explicitly; verify that assignment in WindMil. Consumer demand in the subdivision candidate remains zero pending load data.

## Recommended assistant workflow

1. Identify the requested Lua operation, object types, and fields.
2. Retrieve matching function, field, and working script records with the command above.
3. Read full `--detail` records and nearby source examples before drafting.
4. Use exact catalog names and explain any missing runtime behavior or model assumption.
5. When a task writes a model, compare its import/export with a WindMil export and fold corrections into the next version.
