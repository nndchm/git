# Helpers shared by the test scripts for comparing log graphs.

sanitize_output() {
	sed -e 's/ *$//' \
	    -e 's/commit [0-9a-f]*$/commit COMMIT_OBJECT_NAME/' \
	    -e 's/Merge: [ 0-9a-f]*$/Merge: MERGE_PARENTS/' \
	    -e 's/Merge tag.*/Merge HEADS DESCRIPTION/' \
	    -e 's/Merge commit.*/Merge HEADS DESCRIPTION/' \
	    -e 's/, 0 deletions(-)//' \
	    -e 's/, 0 insertions(+)//' \
	    -e 's/ 1 files changed, / 1 file changed, /' \
	    -e 's/, 1 deletions(-)/, 1 deletion(-)/' \
	    -e 's/, 1 insertions(+)/, 1 insertion(+)/' \
	    -e 's/index [0-9a-f]*\.\.[0-9a-f]*/index BEFORE..AFTER/'
}

# Assume expected graph is in file `expect`
test_cmp_graph_file() {
	git log --graph "$@" >output &&
	sanitize_output >output.trimmed <output &&
	test_i18ncmp expect output.trimmed
}

test_cmp_graph() {
	cat >expect &&
	test_cmp_graph_file "$@"
}

# Assume expected graph is in file `expect.colors`
test_cmp_colored_graph_file() {
	git log --graph --color=always "$@" >output.colors.raw &&
	test_decode_color <output.colors.raw | sed "s/ *\$//" >output.colors &&
	test_cmp expect.colors output.colors
}

test_cmp_colored_graph() {
	cat >expect.colors &&
	test_cmp_colored_graph_file "$@"
}
