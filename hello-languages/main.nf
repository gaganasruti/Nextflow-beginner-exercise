nextflow.enable.dsl=2

process SAY_HELLO {

    publishDir 'results', mode: 'copy'

    output:
    path 'greetings.txt'

    script:
    """
    cat > greetings.txt <<'GREETINGS'
    Hello!
    ನಮಸ್ಕಾರ!
    नमस्ते!
    Bonjour!
    こんにちは!
    GREETINGS
    """
}

workflow {
    SAY_HELLO()
}