#!/usr/bin/env python3
"""Turn a CloudLab manifest XML into an SSH config file.

Standalone, stdlib-only -- copy it wherever you need it.

Usage:
    manifest_to_ssh_config.py --manifest experiment.xml
    manifest_to_ssh_config.py --manifest experiment.xml --user myuser --output ssh_config
"""

from __future__ import annotations

import argparse
import sys
import xml.etree.ElementTree as ET

NS = {"geni": "http://www.geni.net/resources/rspec/3"}


def parse_nodes(manifest_path: str) -> list[tuple[str, str, list[str]]]:
    """Return a list of (client_id, ssh_hostname, [ssh_users]) for each node."""
    root = ET.parse(manifest_path).getroot()

    nodes = []
    for node_elem in root.findall("geni:node", NS):
        name = node_elem.get("client_id")
        if not name:
            continue

        ssh_host = None
        ssh_users: list[str] = []
        services = node_elem.find("geni:services", NS)
        if services is not None:
            for login in services.findall("geni:login", NS):
                if ssh_host is None:
                    ssh_host = login.get("hostname")
                user = login.get("username")
                if user and user not in ssh_users:
                    ssh_users.append(user)

        if ssh_host is None:
            print(f"warning: node {name!r} has no SSH login in the manifest, skipping", file=sys.stderr)
            continue

        nodes.append((name, ssh_host, ssh_users))

    nodes.sort(key=lambda n: n[0])
    return nodes


def pick_user(nodes: list[tuple[str, str, list[str]]], explicit: str | None) -> str:
    if explicit:
        return explicit

    all_users: list[str] = []
    for _, _, users in nodes:
        for u in users:
            if u not in all_users:
                all_users.append(u)

    if not all_users:
        print("error: manifest has no SSH login info and no --user given", file=sys.stderr)
        sys.exit(1)
    if len(all_users) > 1:
        picked = sorted(all_users)[0]
        print(
            f"warning: manifest lists multiple SSH users {sorted(all_users)}; "
            f"using {picked!r}. Pass --user to override.",
            file=sys.stderr,
        )
        return picked
    return all_users[0]


def build_ssh_config(nodes: list[tuple[str, str, list[str]]], user: str) -> str:
    lines = []
    for name, ssh_host, _ in nodes:
        lines.append(f"Host {name}")
        lines.append("    StrictHostKeyChecking no")
        lines.append(f"    HostName {ssh_host}")
        lines.append(f"    User {user}")
        lines.append("")
    return "\n".join(lines)


def main() -> int:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--manifest", required=True, help="path to CloudLab manifest XML")
    p.add_argument("--user", default=None, help="SSH username (default: sole/first login in manifest)")
    p.add_argument("--output", default=None, help="write to this path instead of stdout")
    args = p.parse_args()

    nodes = parse_nodes(args.manifest)
    if not nodes:
        print("error: no nodes found in manifest", file=sys.stderr)
        return 1

    user = pick_user(nodes, args.user)
    config = build_ssh_config(nodes, user)

    if args.output:
        with open(args.output, "w") as f:
            f.write(config)
        print(f"wrote {len(nodes)} hosts to {args.output}", file=sys.stderr)
    else:
        sys.stdout.write(config)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
