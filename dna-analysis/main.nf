
nextflow.enable.dsl=2

process ANALYSE_DNA {

    publishDir 'results', mode: 'copy'

    input:
    path sequence_file

    output:
    path 'dna_stats.txt'

    script:
    """
    sequence=\$(tr -d '\\n\\r ' < ${sequence_file} | tr 'a-z' 'A-Z')

    if [ -z "\$sequence" ] || printf '%s' "\$sequence" | grep -qv '^[ATGC]*'; then
        echo "Error: Input must contain only A, T, G and C" >&2
        exit 1
    fi

    length=\${#sequence}
    a_count=\$(printf '%s' "\$sequence" | tr -cd 'A' | wc -c)
    t_count=\$(printf '%s' "\$sequence" | tr -cd 'T' | wc -c)
    g_count=\$(printf '%s' "\$sequence" | tr -cd 'G' | wc -c)
    c_count=\$(printf '%s' "\$sequence" | tr -cd 'C' | wc -c)

    gc_count=\$((g_count + c_count))

    gc_percent=\$(awk -v gc="\$gc_count" -v len="\$length" \
        'BEGIN { printf "%.2f", (gc / len) * 100 }')

    {
        echo "Sequence length: \$length"
        echo "A count: \$a_count"
        echo "T count: \$t_count"
        echo "G count: \$g_count"
        echo "C count: \$c_count"
        echo "GC percentage: \$gc_percent%"
    } > dna_stats.txt
    """
}

workflow {
    sequence_ch = channel.fromPath('sequence.txt')
    ANALYSE_DNA(sequence_ch)
}
