/^saves/ { saves = 1 }
saves && gsub(/jmp test_exit/, "jmp saves") { print "\t\tsta test_exit - 1"; }

/lda branch/ { branch = 1; }
branch && /^cmd/ { branch_cmd = 1; gsub(/jmp/, "jsr"); }
branch_cmd && /sta jmp_page+0,x/ { print "\t\tlda #$02" }
branch_cmd && /lda pb/ { gsub(/pb/, "db") }

(gsub(/172/, "tmp_zp1") || /tmp_zp1/ ) && !zp1 { zp1 = 1; print "tmp_zp1\t\t= $2c"; }
{ gsub(/173/, "tmp_zp1+1") }
gsub(/174/, "tmp_zp2") && !zp2 { zp2 = 1; print "tmp_zp2\t\t= $3b"; }
{ gsub(/175/, "tmp_zp2+1") }

(gsub(/label_1000/, "tmp_page") || /tmp_page/) && !tmp { tmp = 1; print "tmp_page\t= $0500"; }
gsub(/label_0100/, "stack") && !stack { stack = 1; print "stack\t\t= $0100"; }
(gsub(/label_110/, "jmp_page+") || /jmp_page/) && !jmp { jmp = 1; print "jmp_page\t= $0600"; }

{ print }
