alias py='python3'
function pyv() {
    if [ ! -d ".venv" ]; then
        echo "Creating venv. "
        py -m venv .venv
    fi
    source .venv/bin/activate 
}
