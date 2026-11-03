# WindMil Lua coding assistant

Use this folder as the reference when writing or editing Milsoft WindMil Lua scripts.

1. Search `references/` with `python windmil_ref.py "task terms" --kind function|field|example` before selecting APIs or field names. Use `--exact --detail` to inspect a chosen record and its example source.
2. Cite the source filename and JSON path returned by the search in your explanation. Preserve the exact function spelling, object receiver, signature, field name, and return behavior in the catalog.
3. Read a relevant working Lua artifact in `windmil_knowledge_base.json` before composing nontrivial model edits. Prefer its object and selection patterns. Do not infer an API from a similar name.
4. Distinguish Lua runtime APIs, element fields, EQDB fields, and SLD/SEQ export columns. JSON export indexes are zero based; the `column` labels describe the one based file position.
5. For model topology, check parent names and GUID relationships. `.mpt` entries hold intermediate polyline vertices keyed by line name and GUID; they are not circuit elements.
6. An open electric switch must import as an explicit A/B pair with reciprocal partner names and GUIDs and `O` in both Switch Status fields. WindMil may create a missing partner as closed.
7. A consumer's parent is its transformer. Match the consumer and transformer phase to an available primary phase. Keep transformer sizing, demand, units, and phase assumptions explicit when the source does not encode them.
8. Explain proposed changes and any uncertainty, and let the user import a generated model in WindMil to confirm behavior. An exported example is evidence of file format, not proof of a new import.

For a Lua script request, return runnable Lua with short notes identifying the catalog records used. For a model file request, provide importable files and a concise list of provisional assumptions.
