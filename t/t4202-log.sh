. "$TEST_DIRECTORY/lib-terminal.sh"
cat > expect << EOF
=== 804a787 sixth
=== 394ef78 fifth
=== 5d31159 fourth
EOF
test_expect_success 'git log --line-prefix="=== " --no-walk <commits> sorts by commit time' '
	git log --line-prefix="=== " --no-walk --oneline 5d31159 804a787 394ef78 > actual &&
	test_cmp expect actual
'

cat > expect <<EOF
123 * Second
123 * sixth
123 * fifth
123 * fourth
123 * third
123 * second
123 * initial
EOF

test_expect_success 'simple log --graph --line-prefix="123 "' '
	git log --graph --line-prefix="123 " --pretty=tformat:%s >actual &&
	test_cmp expect actual
'

cat > expect <<\EOF
| | | *   Merge branch 'side'
| | | |\
| | | | * side-2
| | | | * side-1
| | | * | Second
| | | * | sixth
| | | * | fifth
| | | * | fourth
| | | |/
| | | * third
| | | * second
| | | * initial
EOF

test_expect_success 'log --graph --line-prefix="| | | " with merge' '
	git log --line-prefix="| | | " --graph --date-order --pretty=tformat:%s |
		sed "s/ *\$//" >actual &&
	test_cmp expect actual
'

cat > expect.colors <<\EOF
*   Merge branch 'side'
<BLUE>|<RESET><CYAN>\<RESET>
<BLUE>|<RESET> * side-2
<BLUE>|<RESET> * side-1
* <CYAN>|<RESET> Second
* <CYAN>|<RESET> sixth
* <CYAN>|<RESET> fifth
* <CYAN>|<RESET> fourth
<CYAN>|<RESET><CYAN>/<RESET>
* third
* second
* initial
EOF

test_expect_success 'log --graph with merge with log.graphColors' '
	test_config log.graphColors " blue,invalid-color, cyan, red  , " &&
	git log --color=always --graph --date-order --pretty=tformat:%s |
		test_decode_color | sed "s/ *\$//" >actual &&
	test_cmp expect.colors actual
'

	git log --oneline --no-decorate >expect.none &&
test_expect_success TTY 'log output on a TTY' '
	git log --oneline --decorate >expect.short &&

	test_terminal git log --oneline >actual &&
	test_cmp expect.short actual
'

cat >expect <<\EOF
*** *   commit COMMIT_OBJECT_NAME
*** |\  Merge: MERGE_PARENTS
*** | | Author: A U Thor <author@example.com>
*** | |
*** | |     Merge HEADS DESCRIPTION
*** | |
*** | * commit COMMIT_OBJECT_NAME
*** | | Author: A U Thor <author@example.com>
*** | |
*** | |     reach
*** | | ---
*** | |  reach.t | 1 +
*** | |  1 file changed, 1 insertion(+)
*** | |
*** | | diff --git a/reach.t b/reach.t
*** | | new file mode 100644
*** | | index 0000000..10c9591
*** | | --- /dev/null
*** | | +++ b/reach.t
*** | | @@ -0,0 +1 @@
*** | | +reach
*** | |
*** |  \
*** *-. \   commit COMMIT_OBJECT_NAME
*** |\ \ \  Merge: MERGE_PARENTS
*** | | | | Author: A U Thor <author@example.com>
*** | | | |
*** | | | |     Merge HEADS DESCRIPTION
*** | | | |
*** | | * | commit COMMIT_OBJECT_NAME
*** | | |/  Author: A U Thor <author@example.com>
*** | | |
*** | | |       octopus-b
*** | | |   ---
*** | | |    octopus-b.t | 1 +
*** | | |    1 file changed, 1 insertion(+)
*** | | |
*** | | |   diff --git a/octopus-b.t b/octopus-b.t
*** | | |   new file mode 100644
*** | | |   index 0000000..d5fcad0
*** | | |   --- /dev/null
*** | | |   +++ b/octopus-b.t
*** | | |   @@ -0,0 +1 @@
*** | | |   +octopus-b
*** | | |
*** | * | commit COMMIT_OBJECT_NAME
*** | |/  Author: A U Thor <author@example.com>
*** | |
*** | |       octopus-a
*** | |   ---
*** | |    octopus-a.t | 1 +
*** | |    1 file changed, 1 insertion(+)
*** | |
*** | |   diff --git a/octopus-a.t b/octopus-a.t
*** | |   new file mode 100644
*** | |   index 0000000..11ee015
*** | |   --- /dev/null
*** | |   +++ b/octopus-a.t
*** | |   @@ -0,0 +1 @@
*** | |   +octopus-a
*** | |
*** * | commit COMMIT_OBJECT_NAME
*** |/  Author: A U Thor <author@example.com>
*** |
*** |       seventh
*** |   ---
*** |    seventh.t | 1 +
*** |    1 file changed, 1 insertion(+)
*** |
*** |   diff --git a/seventh.t b/seventh.t
*** |   new file mode 100644
*** |   index 0000000..9744ffc
*** |   --- /dev/null
*** |   +++ b/seventh.t
*** |   @@ -0,0 +1 @@
*** |   +seventh
*** |
*** *   commit COMMIT_OBJECT_NAME
*** |\  Merge: MERGE_PARENTS
*** | | Author: A U Thor <author@example.com>
*** | |
*** | |     Merge branch 'tangle'
*** | |
*** | *   commit COMMIT_OBJECT_NAME
*** | |\  Merge: MERGE_PARENTS
*** | | | Author: A U Thor <author@example.com>
*** | | |
*** | | |     Merge branch 'side' (early part) into tangle
*** | | |
*** | * |   commit COMMIT_OBJECT_NAME
*** | |\ \  Merge: MERGE_PARENTS
*** | | | | Author: A U Thor <author@example.com>
*** | | | |
*** | | | |     Merge branch 'master' (early part) into tangle
*** | | | |
*** | * | | commit COMMIT_OBJECT_NAME
*** | | | | Author: A U Thor <author@example.com>
*** | | | |
*** | | | |     tangle-a
*** | | | | ---
*** | | | |  tangle-a | 1 +
*** | | | |  1 file changed, 1 insertion(+)
*** | | | |
*** | | | | diff --git a/tangle-a b/tangle-a
*** | | | | new file mode 100644
*** | | | | index 0000000..7898192
*** | | | | --- /dev/null
*** | | | | +++ b/tangle-a
*** | | | | @@ -0,0 +1 @@
*** | | | | +a
*** | | | |
*** * | | |   commit COMMIT_OBJECT_NAME
*** |\ \ \ \  Merge: MERGE_PARENTS
*** | | | | | Author: A U Thor <author@example.com>
*** | | | | |
*** | | | | |     Merge branch 'side'
*** | | | | |
*** | * | | | commit COMMIT_OBJECT_NAME
*** | | |_|/  Author: A U Thor <author@example.com>
*** | |/| |
*** | | | |       side-2
*** | | | |   ---
*** | | | |    2 | 1 +
*** | | | |    1 file changed, 1 insertion(+)
*** | | | |
*** | | | |   diff --git a/2 b/2
*** | | | |   new file mode 100644
*** | | | |   index 0000000..0cfbf08
*** | | | |   --- /dev/null
*** | | | |   +++ b/2
*** | | | |   @@ -0,0 +1 @@
*** | | | |   +2
*** | | | |
*** | * | | commit COMMIT_OBJECT_NAME
*** | | | | Author: A U Thor <author@example.com>
*** | | | |
*** | | | |     side-1
*** | | | | ---
*** | | | |  1 | 1 +
*** | | | |  1 file changed, 1 insertion(+)
*** | | | |
*** | | | | diff --git a/1 b/1
*** | | | | new file mode 100644
*** | | | | index 0000000..d00491f
*** | | | | --- /dev/null
*** | | | | +++ b/1
*** | | | | @@ -0,0 +1 @@
*** | | | | +1
*** | | | |
*** * | | | commit COMMIT_OBJECT_NAME
*** | | | | Author: A U Thor <author@example.com>
*** | | | |
*** | | | |     Second
*** | | | | ---
*** | | | |  one | 1 +
*** | | | |  1 file changed, 1 insertion(+)
*** | | | |
*** | | | | diff --git a/one b/one
*** | | | | new file mode 100644
*** | | | | index 0000000..9a33383
*** | | | | --- /dev/null
*** | | | | +++ b/one
*** | | | | @@ -0,0 +1 @@
*** | | | | +case
*** | | | |
*** * | | | commit COMMIT_OBJECT_NAME
*** | |_|/  Author: A U Thor <author@example.com>
*** |/| |
*** | | |       sixth
*** | | |   ---
*** | | |    a/two | 1 -
*** | | |    1 file changed, 1 deletion(-)
*** | | |
*** | | |   diff --git a/a/two b/a/two
*** | | |   deleted file mode 100644
*** | | |   index 9245af5..0000000
*** | | |   --- a/a/two
*** | | |   +++ /dev/null
*** | | |   @@ -1 +0,0 @@
*** | | |   -ni
*** | | |
*** * | | commit COMMIT_OBJECT_NAME
*** | | | Author: A U Thor <author@example.com>
*** | | |
*** | | |     fifth
*** | | | ---
*** | | |  a/two | 1 +
*** | | |  1 file changed, 1 insertion(+)
*** | | |
*** | | | diff --git a/a/two b/a/two
*** | | | new file mode 100644
*** | | | index 0000000..9245af5
*** | | | --- /dev/null
*** | | | +++ b/a/two
*** | | | @@ -0,0 +1 @@
*** | | | +ni
*** | | |
*** * | | commit COMMIT_OBJECT_NAME
*** |/ /  Author: A U Thor <author@example.com>
*** | |
*** | |       fourth
*** | |   ---
*** | |    ein | 1 +
*** | |    1 file changed, 1 insertion(+)
*** | |
*** | |   diff --git a/ein b/ein
*** | |   new file mode 100644
*** | |   index 0000000..9d7e69f
*** | |   --- /dev/null
*** | |   +++ b/ein
*** | |   @@ -0,0 +1 @@
*** | |   +ichi
*** | |
*** * | commit COMMIT_OBJECT_NAME
*** |/  Author: A U Thor <author@example.com>
*** |
*** |       third
*** |   ---
*** |    ichi | 1 +
*** |    one  | 1 -
*** |    2 files changed, 1 insertion(+), 1 deletion(-)
*** |
*** |   diff --git a/ichi b/ichi
*** |   new file mode 100644
*** |   index 0000000..9d7e69f
*** |   --- /dev/null
*** |   +++ b/ichi
*** |   @@ -0,0 +1 @@
*** |   +ichi
*** |   diff --git a/one b/one
*** |   deleted file mode 100644
*** |   index 9d7e69f..0000000
*** |   --- a/one
*** |   +++ /dev/null
*** |   @@ -1 +0,0 @@
*** |   -ichi
*** |
*** * commit COMMIT_OBJECT_NAME
*** | Author: A U Thor <author@example.com>
*** |
*** |     second
*** | ---
*** |  one | 2 +-
*** |  1 file changed, 1 insertion(+), 1 deletion(-)
*** |
*** | diff --git a/one b/one
*** | index 5626abf..9d7e69f 100644
*** | --- a/one
*** | +++ b/one
*** | @@ -1 +1 @@
*** | -one
*** | +ichi
*** |
*** * commit COMMIT_OBJECT_NAME
***   Author: A U Thor <author@example.com>
***
***       initial
***   ---
***    one | 1 +
***    1 file changed, 1 insertion(+)
***
***   diff --git a/one b/one
***   new file mode 100644
***   index 0000000..5626abf
***   --- /dev/null
***   +++ b/one
***   @@ -0,0 +1 @@
***   +one
EOF

test_expect_success 'log --line-prefix="*** " --graph with diff and stats' '
	git log --line-prefix="*** " --no-renames --graph --pretty=short --stat -p >actual &&
	sanitize_output >actual.sanitized <actual &&
	test_i18ncmp expect actual.sanitized
'

cat >expect <<-\EOF
* reach
|
| A	reach.t
* Merge branch 'tangle'
*   Merge branch 'side'
|\
| * side-2
|
|   A	2
* Second
|
| A	one
* sixth

  D	a/two
EOF

test_expect_success 'log --graph with --name-status' '
	git log --graph --format=%s --name-status tangle..reach >actual &&
	sanitize_output <actual >actual.sanitized &&
	test_cmp expect actual.sanitized
'

cat >expect <<-\EOF
* reach
|
| reach.t
* Merge branch 'tangle'
*   Merge branch 'side'
|\
| * side-2
|
|   2
* Second
|
| one
* sixth

  a/two
EOF

test_expect_success 'log --graph with --name-only' '
	git log --graph --format=%s --name-only tangle..reach >actual &&
	sanitize_output <actual >actual.sanitized &&
	test_cmp expect actual.sanitized
'
