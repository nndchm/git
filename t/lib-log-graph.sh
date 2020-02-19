# Helpers shared by the test scripts for comparing log graphs.

sanitize_output () {
	# Versions of Git that predate 7f814632 ("Use correct grammar
	# in diffstat summary line", 2012-02-01) did not correctly use
	# singular when one path was involved, and a handful of rules
	# were added to work with both older and newer versions of Git
	# back then.  These are probably not relevant anymore, and
	# we'd want to lose them someday...
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
test_cmp_graph_file () {
	git log --graph "$@" >output &&
	sanitize_output >output.sanitized <output &&
	test_i18ncmp expect output.sanitized
}

test_cmp_graph () {
	cat >expect &&
	test_cmp_graph_file "$@"
}

# Assume expected graph is in file `expect.colors`
test_cmp_colored_graph_file () {
	git log --graph --color=always "$@" >output.colors.raw &&
	test_decode_color <output.colors.raw | sed "s/ *\$//" >output.colors &&
	test_cmp expect.colors output.colors
}

test_cmp_colored_graph () {
	cat >expect.colors &&
	test_cmp_colored_graph_file "$@"
}
