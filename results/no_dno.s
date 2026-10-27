
build/doNotOptimiseTest:     file format elf64-x86-64


Disassembly of section .init:

0000000000001000 <_init>:
    1000:	endbr64 
    1004:	sub    $0x8,%rsp
    1008:	mov    0x2fe1(%rip),%rax        # 3ff0 <__gmon_start__@Base>
    100f:	test   %rax,%rax
    1012:	je     1016 <_init+0x16>
    1014:	call   *%rax
    1016:	add    $0x8,%rsp
    101a:	ret    

Disassembly of section .plt:

0000000000001020 <.plt>:
    1020:	push   0x2f72(%rip)        # 3f98 <_GLOBAL_OFFSET_TABLE_+0x8>
    1026:	bnd jmp *0x2f73(%rip)        # 3fa0 <_GLOBAL_OFFSET_TABLE_+0x10>
    102d:	nopl   (%rax)
    1030:	endbr64 
    1034:	push   $0x0
    1039:	bnd jmp 1020 <_init+0x20>
    103f:	nop
    1040:	endbr64 
    1044:	push   $0x1
    1049:	bnd jmp 1020 <_init+0x20>
    104f:	nop
    1050:	endbr64 
    1054:	push   $0x2
    1059:	bnd jmp 1020 <_init+0x20>
    105f:	nop
    1060:	endbr64 
    1064:	push   $0x3
    1069:	bnd jmp 1020 <_init+0x20>
    106f:	nop
    1070:	endbr64 
    1074:	push   $0x4
    1079:	bnd jmp 1020 <_init+0x20>
    107f:	nop
    1080:	endbr64 
    1084:	push   $0x5
    1089:	bnd jmp 1020 <_init+0x20>
    108f:	nop

Disassembly of section .plt.got:

0000000000001090 <__cxa_finalize@plt>:
    1090:	endbr64 
    1094:	bnd jmp *0x2f3d(%rip)        # 3fd8 <__cxa_finalize@GLIBC_2.2.5>
    109b:	nopl   0x0(%rax,%rax,1)

Disassembly of section .plt.sec:

00000000000010a0 <std::random_device::_M_fini()@plt>:
    10a0:	endbr64 
    10a4:	bnd jmp *0x2efd(%rip)        # 3fa8 <std::random_device::_M_fini()@GLIBCXX_3.4.18>
    10ab:	nopl   0x0(%rax,%rax,1)

00000000000010b0 <operator delete(void*, unsigned long)@plt>:
    10b0:	endbr64 
    10b4:	bnd jmp *0x2ef5(%rip)        # 3fb0 <operator delete(void*, unsigned long)@CXXABI_1.3.9>
    10bb:	nopl   0x0(%rax,%rax,1)

00000000000010c0 <__stack_chk_fail@plt>:
    10c0:	endbr64 
    10c4:	bnd jmp *0x2eed(%rip)        # 3fb8 <__stack_chk_fail@GLIBC_2.4>
    10cb:	nopl   0x0(%rax,%rax,1)

00000000000010d0 <std::random_device::_M_getval()@plt>:
    10d0:	endbr64 
    10d4:	bnd jmp *0x2ee5(%rip)        # 3fc0 <std::random_device::_M_getval()@GLIBCXX_3.4.18>
    10db:	nopl   0x0(%rax,%rax,1)

00000000000010e0 <std::random_device::_M_init(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)@plt>:
    10e0:	endbr64 
    10e4:	bnd jmp *0x2edd(%rip)        # 3fc8 <std::random_device::_M_init(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)@GLIBCXX_3.4.21>
    10eb:	nopl   0x0(%rax,%rax,1)

00000000000010f0 <_Unwind_Resume@plt>:
    10f0:	endbr64 
    10f4:	bnd jmp *0x2ed5(%rip)        # 3fd0 <_Unwind_Resume@GCC_3.0>
    10fb:	nopl   0x0(%rax,%rax,1)

Disassembly of section .text:

0000000000001100 <main.cold>:
    1100:	mov    %rbp,%rdi
    1103:	vzeroupper 
    1106:	call   10a0 <std::random_device::_M_fini()@plt>
    110b:	mov    %r12,%rdi
    110e:	call   10f0 <_Unwind_Resume@plt>
    1113:	cs nopw 0x0(%rax,%rax,1)
    111d:	nopl   (%rax)

0000000000001120 <main>:
    1120:	endbr64 
    1124:	push   %r12
    1126:	push   %rbp
    1127:	push   %rbx
    1128:	sub    $0x1000,%rsp
    112f:	orq    $0x0,(%rsp)
    1134:	sub    $0x1000,%rsp
    113b:	orq    $0x0,(%rsp)
    1140:	sub    $0x1000,%rsp
    1147:	orq    $0x0,(%rsp)
    114c:	sub    $0x6c0,%rsp
    1153:	mov    %fs:0x28,%rax
    115c:	mov    %rax,0x36b8(%rsp)
    1164:	xor    %eax,%eax
    1166:	lea    0xfa0(%rsp),%rbp
    116e:	mov    %rbp,%rdi
    1171:	call   15a0 <std::random_device::random_device()>
    1176:	mov    %rbp,%rdi
    1179:	call   10d0 <std::random_device::_M_getval()@plt>
    117e:	mov    %eax,%ecx
    1180:	mov    $0x1,%edx
    1185:	lea    0x2330(%rsp),%rbx
    118d:	mov    %rcx,0x2330(%rsp)
    1195:	nopl   (%rax)
    1198:	mov    %rcx,%rax
    119b:	shr    $0x1e,%rax
    119f:	xor    %rcx,%rax
    11a2:	imul   $0x6c078965,%rax,%rax
    11a9:	lea    (%rax,%rdx,1),%ecx
    11ac:	mov    %rcx,(%rbx,%rdx,8)
    11b0:	add    $0x1,%rdx
    11b4:	cmp    $0x270,%rdx
    11bb:	jne    1198 <main+0x78>
    11bd:	movq   $0x270,0x36b0(%rsp)
    11c9:	mov    %rsp,%r12
    11cc:	nopl   0x0(%rax)
    11d0:	mov    $0x64,%edx
    11d5:	mov    $0x1,%esi
    11da:	mov    %rbx,%rdi
    11dd:	add    $0x4,%r12
    11e1:	call   1320 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]>
    11e6:	mov    %eax,-0x4(%r12)
    11eb:	cmp    %rbp,%r12
    11ee:	jne    11d0 <main+0xb0>
    11f0:	mov    %r12,%rdi
    11f3:	call   10a0 <std::random_device::_M_fini()@plt>
    11f8:	mov    0x36b8(%rsp),%rax
    1200:	sub    %fs:0x28,%rax
    1209:	jne    1219 <main+0xf9>
    120b:	add    $0x36c0,%rsp
    1212:	xor    %eax,%eax
    1214:	pop    %rbx
    1215:	pop    %rbp
    1216:	pop    %r12
    1218:	ret    
    1219:	call   10c0 <__stack_chk_fail@plt>
    121e:	endbr64 
    1222:	mov    %rax,%r12
    1225:	jmp    1100 <main.cold>
    122a:	nopw   0x0(%rax,%rax,1)

0000000000001230 <_start>:
    1230:	endbr64 
    1234:	xor    %ebp,%ebp
    1236:	mov    %rdx,%r9
    1239:	pop    %rsi
    123a:	mov    %rsp,%rdx
    123d:	and    $0xfffffffffffffff0,%rsp
    1241:	push   %rax
    1242:	push   %rsp
    1243:	xor    %r8d,%r8d
    1246:	xor    %ecx,%ecx
    1248:	lea    -0x12f(%rip),%rdi        # 1120 <main>
    124f:	call   *0x2d8b(%rip)        # 3fe0 <__libc_start_main@GLIBC_2.34>
    1255:	hlt    
    1256:	cs nopw 0x0(%rax,%rax,1)

0000000000001260 <deregister_tm_clones>:
    1260:	lea    0x2db1(%rip),%rdi        # 4018 <__TMC_END__>
    1267:	lea    0x2daa(%rip),%rax        # 4018 <__TMC_END__>
    126e:	cmp    %rdi,%rax
    1271:	je     1288 <deregister_tm_clones+0x28>
    1273:	mov    0x2d6e(%rip),%rax        # 3fe8 <_ITM_deregisterTMCloneTable@Base>
    127a:	test   %rax,%rax
    127d:	je     1288 <deregister_tm_clones+0x28>
    127f:	jmp    *%rax
    1281:	nopl   0x0(%rax)
    1288:	ret    
    1289:	nopl   0x0(%rax)

0000000000001290 <register_tm_clones>:
    1290:	lea    0x2d81(%rip),%rdi        # 4018 <__TMC_END__>
    1297:	lea    0x2d7a(%rip),%rsi        # 4018 <__TMC_END__>
    129e:	sub    %rdi,%rsi
    12a1:	mov    %rsi,%rax
    12a4:	shr    $0x3f,%rsi
    12a8:	sar    $0x3,%rax
    12ac:	add    %rax,%rsi
    12af:	sar    %rsi
    12b2:	je     12c8 <register_tm_clones+0x38>
    12b4:	mov    0x2d3d(%rip),%rax        # 3ff8 <_ITM_registerTMCloneTable@Base>
    12bb:	test   %rax,%rax
    12be:	je     12c8 <register_tm_clones+0x38>
    12c0:	jmp    *%rax
    12c2:	nopw   0x0(%rax,%rax,1)
    12c8:	ret    
    12c9:	nopl   0x0(%rax)

00000000000012d0 <__do_global_dtors_aux>:
    12d0:	endbr64 
    12d4:	cmpb   $0x0,0x2d3d(%rip)        # 4018 <__TMC_END__>
    12db:	jne    1308 <__do_global_dtors_aux+0x38>
    12dd:	push   %rbp
    12de:	cmpq   $0x0,0x2cf2(%rip)        # 3fd8 <__cxa_finalize@GLIBC_2.2.5>
    12e6:	mov    %rsp,%rbp
    12e9:	je     12f7 <__do_global_dtors_aux+0x27>
    12eb:	mov    0x2d16(%rip),%rdi        # 4008 <__dso_handle>
    12f2:	call   1090 <__cxa_finalize@plt>
    12f7:	call   1260 <deregister_tm_clones>
    12fc:	movb   $0x1,0x2d15(%rip)        # 4018 <__TMC_END__>
    1303:	pop    %rbp
    1304:	ret    
    1305:	nopl   (%rax)
    1308:	ret    
    1309:	nopl   0x0(%rax)

0000000000001310 <frame_dummy>:
    1310:	endbr64 
    1314:	jmp    1290 <register_tm_clones>
    1319:	nopl   0x0(%rax)

0000000000001320 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]>:
    1320:	push   %r15
    1322:	movslq %esi,%rax
    1325:	push   %r14
    1327:	push   %r13
    1329:	movslq %edx,%r13
    132c:	push   %r12
    132e:	sub    %rax,%r13
    1331:	mov    %rdi,%r12
    1334:	push   %rbp
    1335:	mov    %rax,%rbp
    1338:	mov    $0xfffffffe,%eax
    133d:	push   %rbx
    133e:	sub    $0x8,%rsp
    1342:	cmp    %rax,%r13
    1345:	jbe    1408 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0xe8>
    134b:	mov    $0xffffffff,%eax
    1350:	cmp    %rax,%r13
    1353:	je     1510 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x1f0>
    1359:	mov    $0xffffffff,%edx
    135e:	xor    %esi,%esi
    1360:	mov    %r12,%rdi
    1363:	call   1320 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]>
    1368:	mov    %rax,%rbx
    136b:	mov    0x1380(%r12),%rax
    1373:	shl    $0x20,%rbx
    1377:	cmp    $0x26f,%rax
    137d:	jbe    138f <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x6f>
    137f:	mov    %r12,%rdi
    1382:	call   1660 <std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>::_M_gen_rand()>
    1387:	mov    0x1380(%r12),%rax
    138f:	lea    0x1(%rax),%rdx
    1393:	mov    (%r12,%rax,8),%rax
    1397:	mov    %rdx,0x1380(%r12)
    139f:	mov    %rax,%rdx
    13a2:	shr    $0xb,%rdx
    13a6:	mov    %edx,%edx
    13a8:	xor    %rdx,%rax
    13ab:	mov    %rax,%rdx
    13ae:	shl    $0x7,%rdx
    13b2:	and    $0x9d2c5680,%edx
    13b8:	xor    %rdx,%rax
    13bb:	mov    %rax,%rdx
    13be:	shl    $0xf,%rdx
    13c2:	and    $0xefc60000,%edx
    13c8:	xor    %rdx,%rax
    13cb:	mov    %rax,%rdx
    13ce:	shr    $0x12,%rdx
    13d2:	xor    %rdx,%rax
    13d5:	add    %rax,%rbx
    13d8:	setb   %al
    13db:	movzbl %al,%eax
    13de:	cmp    %rbx,%r13
    13e1:	jb     1359 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x39>
    13e7:	test   %rax,%rax
    13ea:	jne    1359 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x39>
    13f0:	add    $0x8,%rsp
    13f4:	lea    0x0(%rbp,%rbx,1),%eax
    13f8:	pop    %rbx
    13f9:	pop    %rbp
    13fa:	pop    %r12
    13fc:	pop    %r13
    13fe:	pop    %r14
    1400:	pop    %r15
    1402:	ret    
    1403:	nopl   0x0(%rax,%rax,1)
    1408:	mov    0x1380(%rdi),%rax
    140f:	add    $0x1,%r13
    1413:	mov    %r13d,%r15d
    1416:	cmp    $0x26f,%rax
    141c:	ja     1570 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x250>
    1422:	mov    (%r12,%rax,8),%rbx
    1426:	lea    0x1(%rax),%rcx
    142a:	mov    %rcx,0x1380(%r12)
    1432:	mov    %rbx,%rax
    1435:	shr    $0xb,%rax
    1439:	mov    %eax,%eax
    143b:	xor    %rax,%rbx
    143e:	mov    %rbx,%rax
    1441:	shl    $0x7,%rax
    1445:	and    $0x9d2c5680,%eax
    144a:	xor    %rax,%rbx
    144d:	mov    %rbx,%rax
    1450:	shl    $0xf,%rax
    1454:	and    $0xefc60000,%eax
    1459:	xor    %rax,%rbx
    145c:	mov    %rbx,%rax
    145f:	shr    $0x12,%rax
    1463:	xor    %rax,%rbx
    1466:	imul   %r13,%rbx
    146a:	cmp    %ebx,%r13d
    146d:	jbe    1500 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x1e0>
    1473:	mov    %r13d,%eax
    1476:	xor    %edx,%edx
    1478:	neg    %eax
    147a:	div    %r15d
    147d:	mov    %edx,%r14d
    1480:	cmp    %edx,%ebx
    1482:	jb     14dd <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x1bd>
    1484:	jmp    1500 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x1e0>
    1486:	cs nopw 0x0(%rax,%rax,1)
    1490:	mov    (%r12,%rax,8),%rbx
    1494:	lea    0x1(%rax),%rcx
    1498:	mov    %rcx,0x1380(%r12)
    14a0:	mov    %rbx,%rax
    14a3:	shr    $0xb,%rax
    14a7:	mov    %eax,%eax
    14a9:	xor    %rax,%rbx
    14ac:	mov    %rbx,%rax
    14af:	shl    $0x7,%rax
    14b3:	and    $0x9d2c5680,%eax
    14b8:	xor    %rax,%rbx
    14bb:	mov    %rbx,%rax
    14be:	shl    $0xf,%rax
    14c2:	and    $0xefc60000,%eax
    14c7:	xor    %rax,%rbx
    14ca:	mov    %rbx,%rax
    14cd:	shr    $0x12,%rax
    14d1:	xor    %rax,%rbx
    14d4:	imul   %r13,%rbx
    14d8:	cmp    %ebx,%r14d
    14db:	jbe    1500 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x1e0>
    14dd:	mov    %rcx,%rax
    14e0:	cmp    $0x26f,%rcx
    14e7:	jbe    1490 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x170>
    14e9:	mov    %r12,%rdi
    14ec:	call   1660 <std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>::_M_gen_rand()>
    14f1:	mov    0x1380(%r12),%rax
    14f9:	jmp    1490 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x170>
    14fb:	nopl   0x0(%rax,%rax,1)
    1500:	shr    $0x20,%rbx
    1504:	jmp    13f0 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0xd0>
    1509:	nopl   0x0(%rax)
    1510:	mov    0x1380(%rdi),%rax
    1517:	cmp    $0x26f,%rax
    151d:	ja     1588 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x268>
    151f:	mov    (%r12,%rax,8),%rbx
    1523:	lea    0x1(%rax),%rdx
    1527:	mov    %rdx,0x1380(%r12)
    152f:	mov    %rbx,%rax
    1532:	shr    $0xb,%rax
    1536:	mov    %eax,%eax
    1538:	xor    %rax,%rbx
    153b:	mov    %rbx,%rax
    153e:	shl    $0x7,%rax
    1542:	and    $0x9d2c5680,%eax
    1547:	xor    %rax,%rbx
    154a:	mov    %rbx,%rax
    154d:	shl    $0xf,%rax
    1551:	and    $0xefc60000,%eax
    1556:	xor    %rax,%rbx
    1559:	mov    %rbx,%rax
    155c:	shr    $0x12,%rax
    1560:	xor    %rax,%rbx
    1563:	jmp    13f0 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0xd0>
    1568:	nopl   0x0(%rax,%rax,1)
    1570:	call   1660 <std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>::_M_gen_rand()>
    1575:	mov    0x1380(%r12),%rax
    157d:	jmp    1422 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x102>
    1582:	nopw   0x0(%rax,%rax,1)
    1588:	call   1660 <std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>::_M_gen_rand()>
    158d:	mov    0x1380(%r12),%rax
    1595:	jmp    151f <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x1ff>
    1597:	nopw   0x0(%rax,%rax,1)

00000000000015a0 <std::random_device::random_device()>:
    15a0:	endbr64 
    15a4:	push   %rbp
    15a5:	push   %rbx
    15a6:	sub    $0x38,%rsp
    15aa:	mov    %fs:0x28,%rax
    15b3:	mov    %rax,0x28(%rsp)
    15b8:	xor    %eax,%eax
    15ba:	lea    0x10(%rsp),%rbx
    15bf:	mov    $0x6c75,%eax
    15c4:	mov    %rsp,%rsi
    15c7:	mov    %rbx,(%rsp)
    15cb:	movl   $0x61666564,0x10(%rsp)
    15d3:	mov    %ax,0x14(%rsp)
    15d8:	movb   $0x74,0x16(%rsp)
    15dd:	movq   $0x7,0x8(%rsp)
    15e6:	movb   $0x0,0x17(%rsp)
    15eb:	call   10e0 <std::random_device::_M_init(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)@plt>
    15f0:	mov    (%rsp),%rdi
    15f4:	cmp    %rbx,%rdi
    15f7:	je     1607 <std::random_device::random_device()+0x67>
    15f9:	mov    0x10(%rsp),%rax
    15fe:	lea    0x1(%rax),%rsi
    1602:	call   10b0 <operator delete(void*, unsigned long)@plt>
    1607:	mov    0x28(%rsp),%rax
    160c:	sub    %fs:0x28,%rax
    1615:	jne    161e <std::random_device::random_device()+0x7e>
    1617:	add    $0x38,%rsp
    161b:	pop    %rbx
    161c:	pop    %rbp
    161d:	ret    
    161e:	call   10c0 <__stack_chk_fail@plt>
    1623:	endbr64 
    1627:	mov    %rax,%rbp
    162a:	mov    (%rsp),%rdi
    162e:	cmp    %rbx,%rdi
    1631:	je     164c <std::random_device::random_device()+0xac>
    1633:	mov    0x10(%rsp),%rax
    1638:	lea    0x1(%rax),%rsi
    163c:	vzeroupper 
    163f:	call   10b0 <operator delete(void*, unsigned long)@plt>
    1644:	mov    %rbp,%rdi
    1647:	call   10f0 <_Unwind_Resume@plt>
    164c:	vzeroupper 
    164f:	jmp    1644 <std::random_device::random_device()+0xa4>
    1651:	cs nopw 0x0(%rax,%rax,1)
    165b:	nopl   0x0(%rax,%rax,1)

0000000000001660 <std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>::_M_gen_rand()>:
    1660:	endbr64 
    1664:	vmovdqa 0x9b4(%rip),%ymm3        # 2020 <_IO_stdin_used+0x20>
    166c:	mov    %rdi,%rax
    166f:	mov    %rdi,%rdx
    1672:	vmovdqa 0x9c6(%rip),%ymm4        # 2040 <_IO_stdin_used+0x40>
    167a:	vmovdqa 0x9de(%rip),%ymm5        # 2060 <_IO_stdin_used+0x60>
    1682:	vmovdqa 0x9f6(%rip),%ymm6        # 2080 <_IO_stdin_used+0x80>
    168a:	lea    0x700(%rdi),%rcx
    1691:	vpxor  %xmm7,%xmm7,%xmm7
    1695:	nopl   (%rax)
    1698:	vpand  0x8(%rdx),%ymm4,%ymm1
    169d:	vpand  (%rdx),%ymm3,%ymm0
    16a1:	add    $0x20,%rdx
    16a5:	vpor   %ymm1,%ymm0,%ymm0
    16a9:	vpsrlq $0x1,%ymm0,%ymm1
    16ae:	vpand  %ymm5,%ymm0,%ymm0
    16b2:	vpxor  0xc48(%rdx),%ymm1,%ymm1
    16ba:	vpcmpeqq %ymm7,%ymm0,%ymm0
    16bf:	vpxor  %ymm6,%ymm1,%ymm2
    16c3:	vpblendvb %ymm0,%ymm1,%ymm2,%ymm0
    16c9:	vmovdqu %ymm0,-0x20(%rdx)
    16ce:	cmp    %rdx,%rcx
    16d1:	jne    1698 <std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>::_M_gen_rand()+0x38>
    16d3:	vmovdqa 0x945(%rip),%xmm0        # 2020 <_IO_stdin_used+0x20>
    16db:	vmovdqa 0x95d(%rip),%xmm1        # 2040 <_IO_stdin_used+0x40>
    16e3:	vpxor  %xmm7,%xmm7,%xmm7
    16e7:	vpand  0x708(%rax),%xmm1,%xmm1
    16ef:	vpand  0x700(%rax),%xmm0,%xmm0
    16f7:	mov    0x710(%rax),%rdx
    16fe:	mov    0x718(%rax),%rcx
    1705:	vpor   %xmm1,%xmm0,%xmm0
    1709:	vpsrlq $0x1,%xmm0,%xmm1
    170e:	vpand  0x94a(%rip),%xmm0,%xmm0        # 2060 <_IO_stdin_used+0x60>
    1716:	and    $0x7fffffff,%ecx
    171c:	and    $0xffffffff80000000,%rdx
    1723:	vpxor  0x1368(%rax),%xmm1,%xmm1
    172b:	or     %rcx,%rdx
    172e:	vpxor  0x94a(%rip),%xmm1,%xmm2        # 2080 <_IO_stdin_used+0x80>
    1736:	vpcmpeqq %xmm7,%xmm0,%xmm0
    173b:	mov    %rdx,%rcx
    173e:	shr    %rcx
    1741:	xor    0x1378(%rax),%rcx
    1748:	and    $0x1,%edx
    174b:	vpblendvb %xmm0,%xmm1,%xmm2,%xmm0
    1751:	vmovdqu %xmm0,0x700(%rax)
    1759:	je     1763 <std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>::_M_gen_rand()+0x103>
    175b:	mov    $0x9908b0df,%edx
    1760:	xor    %rdx,%rcx
    1763:	mov    %rcx,0x710(%rax)
    176a:	lea    0x718(%rax),%rdx
    1771:	vpxor  %xmm2,%xmm2,%xmm2
    1775:	lea    0x1378(%rax),%rcx
    177c:	vpand  0x8(%rdx),%ymm4,%ymm1
    1781:	vpand  (%rdx),%ymm3,%ymm0
    1785:	add    $0x20,%rdx
    1789:	vpor   %ymm1,%ymm0,%ymm0
    178d:	vpsrlq $0x1,%ymm0,%ymm1
    1792:	vpand  %ymm5,%ymm0,%ymm0
    1796:	vpxor  -0x738(%rdx),%ymm1,%ymm1
    179e:	vpcmpeqq %ymm2,%ymm0,%ymm0
    17a3:	vpxor  %ymm6,%ymm1,%ymm7
    17a7:	vpblendvb %ymm0,%ymm1,%ymm7,%ymm0
    17ad:	vmovdqu %ymm0,-0x20(%rdx)
    17b2:	cmp    %rcx,%rdx
    17b5:	jne    177c <std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>::_M_gen_rand()+0x11c>
    17b7:	mov    0x1378(%rax),%rdx
    17be:	mov    (%rax),%rcx
    17c1:	and    $0xffffffff80000000,%rdx
    17c8:	and    $0x7fffffff,%ecx
    17ce:	or     %rcx,%rdx
    17d1:	mov    %rdx,%rcx
    17d4:	shr    %rcx
    17d7:	xor    0xc60(%rax),%rcx
    17de:	and    $0x1,%edx
    17e1:	je     17eb <std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>::_M_gen_rand()+0x18b>
    17e3:	mov    $0x9908b0df,%edx
    17e8:	xor    %rdx,%rcx
    17eb:	mov    %rcx,0x1378(%rax)
    17f2:	movq   $0x0,0x1380(%rax)
    17fd:	vzeroupper 
    1800:	ret    

Disassembly of section .fini:

0000000000001804 <_fini>:
    1804:	endbr64 
    1808:	sub    $0x8,%rsp
    180c:	add    $0x8,%rsp
    1810:	ret    
