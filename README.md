# Diff

```diff
--- perlio-signal-while.pl	2019-04-12 21:32:43.000000000 +0900
+++ perlio-signal-for.pl	2019-04-12 21:30:19.000000000 +0900
@@ -28,6 +28,6 @@
 alarm 1;
 close C;

-print while <P>;
+print for <P>;
 while (wait() != -1) {}
 print "done\n";
```

```diff
--- perlio-signal-while.pl	2019-04-12 21:32:43.000000000 +0900
+++ perlio-signal-while-safe.pl	2019-04-12 21:31:39.000000000 +0900
@@ -14,17 +14,13 @@
 }

 print "parent $$\n";
-POSIX::sigaction(
-    SIGALRM,
-    POSIX::SigAction->new(
-        sub{
-            print "timeout\n";
-            open my $fh, '<', 'README.md' or die $!;
-            while (<$fh>) {}
-            close $fh;
-        }
-    )
-);
+local $SIG{ALRM} = sub{
+    print "timeout\n";
+    open my $fh, '<', 'README.md' or die $!;
+    while (<$fh>) {}
+    close $fh;
+};
+
 alarm 1;
 close C;
```

# Expected result

```
$ perl perlio-signal-while.pl
parent 7153
timeout
Out of memory!
```

```
$ perl perlio-signal-while-safe.pl
parent 7289
timeout
Out of memory!
```

```
$ perl perlio-signal-for.pl
parent 7456
timeout
42
done
```
