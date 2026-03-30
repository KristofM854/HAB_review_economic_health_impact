#!/usr/bin/env python3
"""
Fix CSV column alignment issues in event_catalog.csv.

Uses anchor-based alignment to correctly assign values to columns when
fields containing commas have caused misalignment during data entry.
"""

import csv
import re
import os
from collections import Counter

INPUT_FILE = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                          "data", "raw", "event_catalog.csv")

EXPECTED_COLS = 71

# Valid values for constrained fields
VALID_EVENT_CATEGORY = {"fish_kill", "human_health", "economic", "mixed"}
VALID_ENVIRONMENT_TYPE = {"marine_coastal", "marine_offshore", "estuarine", "brackish", "fjord", "freshwater_lake", "freshwater_river", ""}
VALID_TAXONOMIC_CLASS = {"Dinophyceae", "Raphidophyceae", "Dictyochophyceae",
                         "Prymnesiophyceae", "Bacillariophyceae", "Cyanophyceae", "Other", ""}
VALID_ECOLOGICAL_IMPACT = {"fish_only", "multi_trophic", "ecosystem_wide", ""}
VALID_FISH_AFFECTED_TYPE = {"farmed", "wild", "both", "unknown", ""}
VALID_SOURCE_TYPE = {"peer_reviewed", "government_report", "news", "industry", "database", "personal_comm", ""}
VALID_QUALITY = {"high", "medium", "low", ""}
VALID_EXTRACTION_AGENT = {"claude", "human", "claude_verified", ""}
VALID_VERIFICATION_STATUS = {"verified", "unverified", "disputed", ""}
VALID_BOOL = {"TRUE", "FALSE", ""}


def fix_row(row, row_num):
    """
    Fix column alignment using anchor points.

    Strategy: Work from both ends toward the middle. The first ~25 columns
    and last ~9 columns are reliably anchored. The middle section may have
    shifts due to missing/extra empty fields and merged text fields.
    """
    if len(row) != EXPECTED_COLS:
        print(f"  WARNING Row {row_num}: unexpected column count {len(row)}")
        return row, False

    # Check if row is already correct
    if is_aligned(row):
        return row, False

    # The row has 71 fields but internal alignment is off.
    # Build a corrected row using anchor-based reconstruction.
    fixed = list(row)  # start with a copy

    # STEP 1: Check bloom/fish area alignment (cols 25-28)
    # Find where bloom_visible (TRUE/FALSE) actually is
    bloom_vis_pos = None
    for j in range(25, 30):
        if fixed[j] in ('TRUE', 'FALSE') and j != 28:  # not fish_affected_type position
            # Check if next field looks like a color or fish_type
            if j + 1 < len(fixed):
                next_val = fixed[j + 1]
                if (next_val in VALID_FISH_AFFECTED_TYPE or
                    next_val in ('red', 'red-brown', 'dark/black', 'green', 'milky', 'brown', '')):
                    bloom_vis_pos = j
                    break

    if bloom_vis_pos is not None and bloom_vis_pos != 26:
        shift = bloom_vis_pos - 26  # positive = shifted right, negative = shifted left

        if shift == 1:
            # bloom_visible at 27 instead of 26: extra empty before it
            # Need to remove one empty from 23-26 range AND split a merged field later
            # OR: remove the extra empty and add one where needed

            # Remove the extra empty at position 26 (shifting bloom_vis to 26)
            del fixed[26]
            # Now we have 70 fields. Need to split a merged field to get back to 71.
            # Look for merged fields in the remaining data
            split_done = False
            # Check common merge points: benthic/ecological area and economic area
            for j in range(43, 56):
                val = fixed[j] if j < len(fixed) else ''
                if ', ' in val:
                    parts = val.split(', ', 1)
                    left, right = parts
                    # Check if left part looks like a standalone value
                    if left in VALID_BOOL or left in VALID_FISH_AFFECTED_TYPE:
                        fixed[j] = left
                        fixed.insert(j + 1, right)
                        split_done = True
                        break
            if not split_done:
                # Restore and give up
                fixed = list(row)
                print(f"  WARNING Row {row_num}: could not find merge point for shift=+1")
                return row, False

        elif shift == -1:
            # bloom_visible at 25 instead of 26: missing empty before it
            # Insert empty at position 25
            fixed.insert(25, '')
            # Now 72 fields. Need to merge or remove one.
            # Look for extra empty field before DOI
            removed = False
            for j in range(61, 55, -1):
                if j < len(fixed) and fixed[j] == '':
                    del fixed[j]
                    removed = True
                    break
            if not removed:
                fixed = list(row)
                print(f"  WARNING Row {row_num}: could not find empty to remove for shift=-1")
                return row, False

    # STEP 2: Check if fish_affected_type is now correct
    if fixed[28] not in VALID_FISH_AFFECTED_TYPE:
        # Try finding fish_affected_type in nearby positions
        for j in range(26, 31):
            if fixed[j] in VALID_FISH_AFFECTED_TYPE and fixed[j] != '':
                # This is likely the fish_affected_type
                if j < 28:
                    # Shifted left: need to insert empties before it
                    for _ in range(28 - j):
                        fixed.insert(j, '')
                    # Remove same number of empties from later
                    removed = 0
                    for k in range(61, 55, -1):
                        if k < len(fixed) and fixed[k] == '' and removed < (28 - j):
                            del fixed[k]
                            removed += 1
                elif j > 28:
                    # Shifted right: remove empties before it
                    for _ in range(j - 28):
                        # Find empty to remove between 26 and j
                        for k in range(26, j):
                            if fixed[k] == '':
                                del fixed[k]
                                break
                    # Insert empties later
                    for _ in range(j - 28):
                        if len(fixed) < EXPECTED_COLS:
                            fixed.insert(61, '')
                break

    # STEP 3: Handle merged fields in economic_notes/desalination area
    # Check if col 55 (economic_notes area) has "FALSE, text" pattern
    for j in range(53, 57):
        if j < len(fixed) and ', ' in fixed[j]:
            val = fixed[j]
            parts = val.split(', ', 1)
            if parts[0] in ('TRUE', 'FALSE'):
                # Check if splitting this would help alignment
                # Only split if we're currently at 70 fields (need one more)
                if len(fixed) < EXPECTED_COLS:
                    fixed[j] = parts[0]
                    fixed.insert(j + 1, parts[1])

    # Ensure correct length
    while len(fixed) < EXPECTED_COLS:
        # Insert empties before DOI
        fixed.insert(61, '')
    while len(fixed) > EXPECTED_COLS:
        # Remove empties before DOI
        removed = False
        for j in range(62, 55, -1):
            if j < len(fixed) and fixed[j] == '':
                del fixed[j]
                removed = True
                break
        if not removed:
            break

    if len(fixed) != EXPECTED_COLS:
        print(f"  WARNING Row {row_num}: could not achieve {EXPECTED_COLS} cols, got {len(fixed)}")
        return list(row), False

    was_fixed = (fixed != list(row))
    return fixed, was_fixed


def is_aligned(row):
    """Check if a row is correctly aligned based on anchor fields."""
    if row[28] not in VALID_FISH_AFFECTED_TYPE:
        return False
    if row[40] not in VALID_ECOLOGICAL_IMPACT:
        return False
    if row[64] not in VALID_SOURCE_TYPE:
        return False
    if row[65] not in VALID_QUALITY:
        return False
    if row[68] not in VALID_EXTRACTION_AGENT:
        return False
    if row[69] not in VALID_VERIFICATION_STATUS:
        return False
    if not re.match(r'^\d{4}-\d{2}-\d{2}$', row[67]):
        return False
    return True


def validate_row(row, row_num):
    """Validate a row against all known constraints. Returns list of issues."""
    issues = []

    if not re.match(r'^[A-Z]{3}_\d{4}_\d{3}$', row[0]):
        issues.append(f"event_id '{row[0]}' invalid")
    if row[2] not in VALID_EVENT_CATEGORY:
        issues.append(f"event_category '{row[2]}' invalid")
    if not re.match(r'^\d{4}$', row[3]):
        issues.append(f"year '{row[3]}' invalid")
    if row[16] not in VALID_ENVIRONMENT_TYPE:
        issues.append(f"environment_type '{row[16]}' invalid")
    if row[21] not in VALID_TAXONOMIC_CLASS:
        issues.append(f"taxonomic_class '{row[21]}' invalid")
    if row[28] not in VALID_FISH_AFFECTED_TYPE:
        issues.append(f"fish_affected_type '{row[28]}' invalid")
    if row[40] not in VALID_ECOLOGICAL_IMPACT:
        issues.append(f"ecological_impact_level '{row[40]}' invalid")
    if row[62] and not re.match(r'^10\.\d{4,}/', row[62]):
        issues.append(f"source_doi_primary '{row[62][:40]}' invalid")
    if row[64] not in VALID_SOURCE_TYPE:
        issues.append(f"source_type '{row[64]}' invalid")
    if row[65] not in VALID_QUALITY:
        issues.append(f"data_quality '{row[65]}' invalid")
    if row[66] not in VALID_QUALITY:
        issues.append(f"extraction_confidence '{row[66]}' invalid")
    if not re.match(r'^\d{4}-\d{2}-\d{2}$', row[67]):
        issues.append(f"extraction_date '{row[67]}' invalid")
    if row[68] not in VALID_EXTRACTION_AGENT:
        issues.append(f"extraction_agent '{row[68]}' invalid")
    if row[69] not in VALID_VERIFICATION_STATUS:
        issues.append(f"verification_status '{row[69]}' invalid")

    return issues


def main():
    with open(INPUT_FILE, newline='') as f:
        reader = csv.reader(f)
        header = next(reader)
        rows = list(reader)

    print(f"Read {len(rows)} data rows, header has {len(header)} columns")
    print(f"Expected: {EXPECTED_COLS} columns per row")
    print()

    # Pre-fix validation
    pre_issues = 0
    pre_issue_rows = 0
    for i, row in enumerate(rows, 1):
        issues = validate_row(row, i)
        if issues:
            pre_issues += len(issues)
            pre_issue_rows += 1
    print(f"Pre-fix: {pre_issues} validation issues in {pre_issue_rows} rows")
    print()

    fixed_count = 0
    all_issues = []
    fixed_rows = []

    for i, row in enumerate(rows):
        row_num = i + 1
        fixed_row, was_fixed = fix_row(row, row_num)
        if was_fixed:
            fixed_count += 1
            print(f"  Fixed row {row_num} ({row[0]})")

        issues = validate_row(fixed_row, row_num)
        if issues:
            all_issues.append((row_num, fixed_row[0], issues))

        fixed_rows.append(fixed_row)

    print()
    print(f"Rows fixed: {fixed_count} out of {len(rows)}")

    # Write output
    with open(INPUT_FILE, 'w', newline='') as f:
        writer = csv.writer(f, quoting=csv.QUOTE_ALL)
        writer.writerow(header)
        writer.writerows(fixed_rows)

    print(f"File rewritten with csv.QUOTE_ALL")
    print()

    # Summary
    cat_counts = Counter(r[2] for r in fixed_rows)
    print("=== Event Category Counts ===")
    for cat, count in sorted(cat_counts.items()):
        print(f"  {cat}: {count}")
    print()

    country_counts = Counter(r[9] for r in fixed_rows)
    print("=== Country Counts ===")
    for country, count in sorted(country_counts.items()):
        print(f"  {country}: {count}")
    print()

    if all_issues:
        print(f"=== Remaining Validation Issues ({sum(len(x[2]) for x in all_issues)} total in {len(all_issues)} rows) ===")
        for row_num, event_id, issues in all_issues:
            for issue in issues:
                print(f"  Row {row_num} ({event_id}): {issue}")
    else:
        print("=== No Validation Issues - All fields validate correctly ===")
    print()

    # Verify column counts
    with open(INPUT_FILE, newline='') as f:
        reader = csv.reader(f)
        next(reader)
        bad = [(i, len(r)) for i, r in enumerate(reader, 1) if len(r) != EXPECTED_COLS]
    if bad:
        print(f"WARNING: {len(bad)} rows with wrong column count")
        for rn, nc in bad:
            print(f"  Row {rn}: {nc} cols")
    else:
        print(f"All {len(rows)} data rows have exactly {EXPECTED_COLS} columns.")


if __name__ == "__main__":
    main()
