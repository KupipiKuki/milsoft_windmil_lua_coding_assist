#!/usr/bin/env python3
"""Search the supplied Milsoft WindMil JSON reference catalogs locally."""
import argparse
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent / "references"


def load(name):
    return json.loads((ROOT / name).read_text(encoding="utf-8"))


def records():
    fn = "windmil_knowledge_functions.json"
    for i, item in enumerate(load(fn)["artifacts"]):
        yield {"kind": "function", "name": item.get("name", ""),
               "source": f"{fn}#artifacts/{i}", "data": item}

    fn = "windmil_knowledge_fields.json"
    catalog = load(fn)
    for section in ("elements", "studies", "reports"):
        for group, value in catalog[section].items():
            for i, item in enumerate(value.get("fields", [])):
                yield {"kind": "field", "name": item.get("field_name", ""),
                       "group": f"{section}/{group}",
                       "source": f"{fn}#{section}/{group}/fields/{i}", "data": item}

    fn = "windmil_knowledge_base.json"
    for i, item in enumerate(load(fn)["artifacts"]):
        yield {"kind": "example", "name": item.get("metadata", {}).get("file_name", item.get("id", "")),
               "source": f"{fn}#artifacts/{i}", "data": item}

    for kind, fn in (("sld", "windmil_sld_format.json"),
                     ("seq", "windmil_seq_format.json")):
        for group, columns in load(fn).items():
            for key, item in columns.items():
                if isinstance(item, dict) and "description" in item:
                    yield {"kind": kind, "name": item["description"],
                           "group": group, "source": f"{fn}#{group}/{key}", "data": item}

    for fn in ("windmil_circuit_elements_help_file.json",
               "windmil_circuit_defaults_help_file.json",
               "windmil_eqdb_help_file.json",
               "windmil_system_preferences_help_file.json"):
        for section, item in load(fn).items():
            yield {"kind": "help", "name": section, "source": f"{fn}#{section}", "data": item}


def description(record):
    data = record["data"]
    if record["kind"] == "example":
        return str(data.get("metadata", {}).get("description", ""))
    if isinstance(data, dict):
        return str(data.get("description", ""))
    return str(data)


def score(record, query):
    words = re.findall(r"[\w]+", query.casefold())
    name = record["name"].casefold()
    head = (name + " " + record.get("group", "") + " " + description(record)).casefold()
    body = json.dumps(record["data"], ensure_ascii=False).casefold()
    if not words or not all(word in body + " " + head for word in words):
        return 0
    return sum(100 if name == query.casefold() else 30 if word in name
               else 8 if word in head else 1 for word in words)


def compact(record, detail=False):
    result = {key: record[key] for key in ("kind", "name", "group", "source") if key in record}
    if detail:
        result["data"] = record["data"]
    else:
        result["description"] = description(record)[:500]
        data = record["data"]
        if record["kind"] == "function":
            for key in ("object", "signature", "return", "example", "where_used"):
                if data.get(key): result[key] = data[key]
        if record["kind"] == "example":
            result["id"] = data.get("id")
            result["path"] = data.get("path")
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("query", nargs="+", help="words or exact identifier to find")
    parser.add_argument("--kind", choices=("all", "function", "field", "example", "sld", "seq", "help"), default="all")
    parser.add_argument("--limit", type=int, default=8)
    parser.add_argument("--exact", action="store_true", help="match name exactly, ignoring case")
    parser.add_argument("--detail", action="store_true", help="show complete JSON records, including Lua example source")
    parser.add_argument("--json", action="store_true", help="emit machine-readable JSON")
    args = parser.parse_args()
    query = " ".join(args.query).strip()
    matches = []
    for record in records():
        if args.kind != "all" and record["kind"] != args.kind: continue
        relevance = score(record, query)
        if args.exact and record["name"].casefold() != query.casefold(): continue
        if relevance: matches.append((relevance, record))
    matches.sort(key=lambda entry: (-entry[0], entry[1]["kind"], entry[1]["name"]))
    selected = [compact(r, args.detail) for _, r in matches[:max(1, args.limit)]]
    if args.json:
        print(json.dumps(selected, ensure_ascii=False, indent=2))
    else:
        for item in selected:
            print(f"[{item['kind']}] {item['name']}  ({item['source']})")
            if item.get("group"): print("  group:", item["group"])
            for key in ("signature", "description", "example", "return"):
                if item.get(key): print(f"  {key}: {str(item[key])[:900]}")
            if args.detail: print(json.dumps(item["data"], ensure_ascii=False, indent=2))
        if not selected: print("No matching records.")


if __name__ == "__main__":
    main()
