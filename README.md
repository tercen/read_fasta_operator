# Read FASTA operator

##### Description

`read_fasta` operator reads a FASTA file into Tercen.

##### Usage

Input projection|.
---|---
`col`        | factor, document ID

Output relations|.
---|---
`name`        | factor, sequence name
`position`    | numeric, position of amino or nucleic acid in the sequence
`letter`      | factor, letter corresponding to an amino or nucleic acid
`value`       | numeric, numeric value associated to an amino or nucleic acid

##### Details

This opeartor reads a FASTA file and returns a table with one row per sequence per letter. Columns correspond to the sequence `name` (extracted from identifier lines starting with `>`), `position` on the sequence (starting from `1` at the beginning of the sequence), the `letter` (corresponding to an amino or nucleic acid), and a `value` (corresponding to a numeric encoding of letters for visualisation purposes).

##### References

[FASTA format on Wikipedia](https://en.wikipedia.org/wiki/FASTA_format).

##### See Also

[msa_operator](https://github.com/tercen/msa_operator)
