
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
    1100:	mov    %r12,%rdi
    1103:	vzeroupper 
    1106:	call   10a0 <std::random_device::_M_fini()@plt>
    110b:	mov    %r13,%rdi
    110e:	call   10f0 <_Unwind_Resume@plt>
    1113:	cs nopw 0x0(%rax,%rax,1)
    111d:	nopl   (%rax)

0000000000001120 <main>:
    1120:	endbr64 
    1124:	push   %rbp
    1125:	mov    %rsp,%rbp
    1128:	push   %r14
    112a:	push   %r13
    112c:	push   %r12
    112e:	push   %rbx
    112f:	and    $0xffffffffffffffe0,%rsp
    1133:	sub    $0x1000,%rsp
    113a:	orq    $0x0,(%rsp)
    113f:	sub    $0x1000,%rsp
    1146:	orq    $0x0,(%rsp)
    114b:	sub    $0x1000,%rsp
    1152:	orq    $0x0,(%rsp)
    1157:	sub    $0x6c0,%rsp
    115e:	mov    %fs:0x28,%rax
    1167:	mov    %rax,0x36b8(%rsp)
    116f:	xor    %eax,%eax
    1171:	lea    0xfa0(%rsp),%r12
    1179:	mov    %r12,%rdi
    117c:	call   1600 <std::random_device::random_device()>
    1181:	mov    %r12,%rdi
    1184:	call   10d0 <std::random_device::_M_getval()@plt>
    1189:	mov    %eax,%ecx
    118b:	mov    $0x1,%edx
    1190:	lea    0x2330(%rsp),%rbx
    1198:	mov    %rcx,0x2330(%rsp)
    11a0:	mov    %rcx,%rax
    11a3:	shr    $0x1e,%rax
    11a7:	xor    %rcx,%rax
    11aa:	imul   $0x6c078965,%rax,%rax
    11b1:	lea    (%rax,%rdx,1),%ecx
    11b4:	mov    %rcx,(%rbx,%rdx,8)
    11b8:	add    $0x1,%rdx
    11bc:	cmp    $0x270,%rdx
    11c3:	jne    11a0 <main+0x80>
    11c5:	movq   $0x270,0x36b0(%rsp)
    11d1:	mov    %rsp,%r14
    11d4:	mov    %r14,%r13
    11d7:	nopw   0x0(%rax,%rax,1)
    11e0:	mov    $0x64,%edx
    11e5:	mov    $0x1,%esi
    11ea:	mov    %rbx,%rdi
    11ed:	add    $0x4,%r13
    11f1:	call   1380 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]>
    11f6:	mov    %eax,-0x4(%r13)
    11fa:	cmp    %r12,%r13
    11fd:	jne    11e0 <main+0xc0>
    11ff:	mov    %r14,%rdi
    1202:	vpxor  %xmm0,%xmm0,%xmm0
    1206:	cs nopw 0x0(%rax,%rax,1)
    1210:	vpmovsxdq (%rdi),%ymm1
    1215:	vmovdqa (%rdi),%ymm2
    1219:	add    $0x20,%rdi
    121d:	vpaddq %ymm0,%ymm1,%ymm1
    1221:	vextracti128 $0x1,%ymm2,%xmm0
    1227:	vpmovsxdq %xmm0,%ymm0
    122c:	vpaddq %ymm1,%ymm0,%ymm0
    1230:	cmp    %r12,%rdi
    1233:	jne    1210 <main+0xf0>
    1235:	vmovdqa %xmm0,%xmm1
    1239:	vextracti128 $0x1,%ymm0,%xmm0
    123f:	vpaddq %xmm0,%xmm1,%xmm0
    1243:	vpsrldq $0x8,%xmm0,%xmm1
    1248:	vpaddq %xmm1,%xmm0,%xmm0
    124c:	vmovq  %xmm0,%rax
    1251:	vzeroupper 
    1254:	call   10a0 <std::random_device::_M_fini()@plt>
    1259:	mov    0x36b8(%rsp),%rax
    1261:	sub    %fs:0x28,%rax
    126a:	jne    127b <main+0x15b>
    126c:	lea    -0x20(%rbp),%rsp
    1270:	xor    %eax,%eax
    1272:	pop    %rbx
    1273:	pop    %r12
    1275:	pop    %r13
    1277:	pop    %r14
    1279:	pop    %rbp
    127a:	ret    
    127b:	call   10c0 <__stack_chk_fail@plt>
    1280:	endbr64 
    1284:	mov    %rax,%r13
    1287:	jmp    1100 <main.cold>
    128c:	nopl   0x0(%rax)

0000000000001290 <_start>:
    1290:	endbr64 
    1294:	xor    %ebp,%ebp
    1296:	mov    %rdx,%r9
    1299:	pop    %rsi
    129a:	mov    %rsp,%rdx
    129d:	and    $0xfffffffffffffff0,%rsp
    12a1:	push   %rax
    12a2:	push   %rsp
    12a3:	xor    %r8d,%r8d
    12a6:	xor    %ecx,%ecx
    12a8:	lea    -0x18f(%rip),%rdi        # 1120 <main>
    12af:	call   *0x2d2b(%rip)        # 3fe0 <__libc_start_main@GLIBC_2.34>
    12b5:	hlt    
    12b6:	cs nopw 0x0(%rax,%rax,1)

00000000000012c0 <deregister_tm_clones>:
    12c0:	lea    0x2d51(%rip),%rdi        # 4018 <__TMC_END__>
    12c7:	lea    0x2d4a(%rip),%rax        # 4018 <__TMC_END__>
    12ce:	cmp    %rdi,%rax
    12d1:	je     12e8 <deregister_tm_clones+0x28>
    12d3:	mov    0x2d0e(%rip),%rax        # 3fe8 <_ITM_deregisterTMCloneTable@Base>
    12da:	test   %rax,%rax
    12dd:	je     12e8 <deregister_tm_clones+0x28>
    12df:	jmp    *%rax
    12e1:	nopl   0x0(%rax)
    12e8:	ret    
    12e9:	nopl   0x0(%rax)

00000000000012f0 <register_tm_clones>:
    12f0:	lea    0x2d21(%rip),%rdi        # 4018 <__TMC_END__>
    12f7:	lea    0x2d1a(%rip),%rsi        # 4018 <__TMC_END__>
    12fe:	sub    %rdi,%rsi
    1301:	mov    %rsi,%rax
    1304:	shr    $0x3f,%rsi
    1308:	sar    $0x3,%rax
    130c:	add    %rax,%rsi
    130f:	sar    %rsi
    1312:	je     1328 <register_tm_clones+0x38>
    1314:	mov    0x2cdd(%rip),%rax        # 3ff8 <_ITM_registerTMCloneTable@Base>
    131b:	test   %rax,%rax
    131e:	je     1328 <register_tm_clones+0x38>
    1320:	jmp    *%rax
    1322:	nopw   0x0(%rax,%rax,1)
    1328:	ret    
    1329:	nopl   0x0(%rax)

0000000000001330 <__do_global_dtors_aux>:
    1330:	endbr64 
    1334:	cmpb   $0x0,0x2cdd(%rip)        # 4018 <__TMC_END__>
    133b:	jne    1368 <__do_global_dtors_aux+0x38>
    133d:	push   %rbp
    133e:	cmpq   $0x0,0x2c92(%rip)        # 3fd8 <__cxa_finalize@GLIBC_2.2.5>
    1346:	mov    %rsp,%rbp
    1349:	je     1357 <__do_global_dtors_aux+0x27>
    134b:	mov    0x2cb6(%rip),%rdi        # 4008 <__dso_handle>
    1352:	call   1090 <__cxa_finalize@plt>
    1357:	call   12c0 <deregister_tm_clones>
    135c:	movb   $0x1,0x2cb5(%rip)        # 4018 <__TMC_END__>
    1363:	pop    %rbp
    1364:	ret    
    1365:	nopl   (%rax)
    1368:	ret    
    1369:	nopl   0x0(%rax)

0000000000001370 <frame_dummy>:
    1370:	endbr64 
    1374:	jmp    12f0 <register_tm_clones>
    1379:	nopl   0x0(%rax)

0000000000001380 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]>:
    1380:	push   %r15
    1382:	movslq %esi,%rax
    1385:	push   %r14
    1387:	push   %r13
    1389:	movslq %edx,%r13
    138c:	push   %r12
    138e:	sub    %rax,%r13
    1391:	mov    %rdi,%r12
    1394:	push   %rbp
    1395:	mov    %rax,%rbp
    1398:	mov    $0xfffffffe,%eax
    139d:	push   %rbx
    139e:	sub    $0x8,%rsp
    13a2:	cmp    %rax,%r13
    13a5:	jbe    1468 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0xe8>
    13ab:	mov    $0xffffffff,%eax
    13b0:	cmp    %rax,%r13
    13b3:	je     1570 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x1f0>
    13b9:	mov    $0xffffffff,%edx
    13be:	xor    %esi,%esi
    13c0:	mov    %r12,%rdi
    13c3:	call   1380 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]>
    13c8:	mov    %rax,%rbx
    13cb:	mov    0x1380(%r12),%rax
    13d3:	shl    $0x20,%rbx
    13d7:	cmp    $0x26f,%rax
    13dd:	jbe    13ef <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x6f>
    13df:	mov    %r12,%rdi
    13e2:	call   16c0 <std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>::_M_gen_rand()>
    13e7:	mov    0x1380(%r12),%rax
    13ef:	lea    0x1(%rax),%rdx
    13f3:	mov    (%r12,%rax,8),%rax
    13f7:	mov    %rdx,0x1380(%r12)
    13ff:	mov    %rax,%rdx
    1402:	shr    $0xb,%rdx
    1406:	mov    %edx,%edx
    1408:	xor    %rdx,%rax
    140b:	mov    %rax,%rdx
    140e:	shl    $0x7,%rdx
    1412:	and    $0x9d2c5680,%edx
    1418:	xor    %rdx,%rax
    141b:	mov    %rax,%rdx
    141e:	shl    $0xf,%rdx
    1422:	and    $0xefc60000,%edx
    1428:	xor    %rdx,%rax
    142b:	mov    %rax,%rdx
    142e:	shr    $0x12,%rdx
    1432:	xor    %rdx,%rax
    1435:	add    %rax,%rbx
    1438:	setb   %al
    143b:	movzbl %al,%eax
    143e:	cmp    %rbx,%r13
    1441:	jb     13b9 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x39>
    1447:	test   %rax,%rax
    144a:	jne    13b9 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x39>
    1450:	add    $0x8,%rsp
    1454:	lea    0x0(%rbp,%rbx,1),%eax
    1458:	pop    %rbx
    1459:	pop    %rbp
    145a:	pop    %r12
    145c:	pop    %r13
    145e:	pop    %r14
    1460:	pop    %r15
    1462:	ret    
    1463:	nopl   0x0(%rax,%rax,1)
    1468:	mov    0x1380(%rdi),%rax
    146f:	add    $0x1,%r13
    1473:	mov    %r13d,%r15d
    1476:	cmp    $0x26f,%rax
    147c:	ja     15d0 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x250>
    1482:	mov    (%r12,%rax,8),%rbx
    1486:	lea    0x1(%rax),%rcx
    148a:	mov    %rcx,0x1380(%r12)
    1492:	mov    %rbx,%rax
    1495:	shr    $0xb,%rax
    1499:	mov    %eax,%eax
    149b:	xor    %rax,%rbx
    149e:	mov    %rbx,%rax
    14a1:	shl    $0x7,%rax
    14a5:	and    $0x9d2c5680,%eax
    14aa:	xor    %rax,%rbx
    14ad:	mov    %rbx,%rax
    14b0:	shl    $0xf,%rax
    14b4:	and    $0xefc60000,%eax
    14b9:	xor    %rax,%rbx
    14bc:	mov    %rbx,%rax
    14bf:	shr    $0x12,%rax
    14c3:	xor    %rax,%rbx
    14c6:	imul   %r13,%rbx
    14ca:	cmp    %ebx,%r13d
    14cd:	jbe    1560 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x1e0>
    14d3:	mov    %r13d,%eax
    14d6:	xor    %edx,%edx
    14d8:	neg    %eax
    14da:	div    %r15d
    14dd:	mov    %edx,%r14d
    14e0:	cmp    %edx,%ebx
    14e2:	jb     153d <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x1bd>
    14e4:	jmp    1560 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x1e0>
    14e6:	cs nopw 0x0(%rax,%rax,1)
    14f0:	mov    (%r12,%rax,8),%rbx
    14f4:	lea    0x1(%rax),%rcx
    14f8:	mov    %rcx,0x1380(%r12)
    1500:	mov    %rbx,%rax
    1503:	shr    $0xb,%rax
    1507:	mov    %eax,%eax
    1509:	xor    %rax,%rbx
    150c:	mov    %rbx,%rax
    150f:	shl    $0x7,%rax
    1513:	and    $0x9d2c5680,%eax
    1518:	xor    %rax,%rbx
    151b:	mov    %rbx,%rax
    151e:	shl    $0xf,%rax
    1522:	and    $0xefc60000,%eax
    1527:	xor    %rax,%rbx
    152a:	mov    %rbx,%rax
    152d:	shr    $0x12,%rax
    1531:	xor    %rax,%rbx
    1534:	imul   %r13,%rbx
    1538:	cmp    %ebx,%r14d
    153b:	jbe    1560 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x1e0>
    153d:	mov    %rcx,%rax
    1540:	cmp    $0x26f,%rcx
    1547:	jbe    14f0 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x170>
    1549:	mov    %r12,%rdi
    154c:	call   16c0 <std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>::_M_gen_rand()>
    1551:	mov    0x1380(%r12),%rax
    1559:	jmp    14f0 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x170>
    155b:	nopl   0x0(%rax,%rax,1)
    1560:	shr    $0x20,%rbx
    1564:	jmp    1450 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0xd0>
    1569:	nopl   0x0(%rax)
    1570:	mov    0x1380(%rdi),%rax
    1577:	cmp    $0x26f,%rax
    157d:	ja     15e8 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x268>
    157f:	mov    (%r12,%rax,8),%rbx
    1583:	lea    0x1(%rax),%rdx
    1587:	mov    %rdx,0x1380(%r12)
    158f:	mov    %rbx,%rax
    1592:	shr    $0xb,%rax
    1596:	mov    %eax,%eax
    1598:	xor    %rax,%rbx
    159b:	mov    %rbx,%rax
    159e:	shl    $0x7,%rax
    15a2:	and    $0x9d2c5680,%eax
    15a7:	xor    %rax,%rbx
    15aa:	mov    %rbx,%rax
    15ad:	shl    $0xf,%rax
    15b1:	and    $0xefc60000,%eax
    15b6:	xor    %rax,%rbx
    15b9:	mov    %rbx,%rax
    15bc:	shr    $0x12,%rax
    15c0:	xor    %rax,%rbx
    15c3:	jmp    1450 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0xd0>
    15c8:	nopl   0x0(%rax,%rax,1)
    15d0:	call   16c0 <std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>::_M_gen_rand()>
    15d5:	mov    0x1380(%r12),%rax
    15dd:	jmp    1482 <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x102>
    15e2:	nopw   0x0(%rax,%rax,1)
    15e8:	call   16c0 <std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>::_M_gen_rand()>
    15ed:	mov    0x1380(%r12),%rax
    15f5:	jmp    157f <int std::uniform_int_distribution<int>::operator()<std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul> >(std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>&, std::uniform_int_distribution<int>::param_type const&) [clone .isra.0]+0x1ff>
    15f7:	nopw   0x0(%rax,%rax,1)

0000000000001600 <std::random_device::random_device()>:
    1600:	endbr64 
    1604:	push   %rbp
    1605:	push   %rbx
    1606:	sub    $0x38,%rsp
    160a:	mov    %fs:0x28,%rax
    1613:	mov    %rax,0x28(%rsp)
    1618:	xor    %eax,%eax
    161a:	lea    0x10(%rsp),%rbx
    161f:	mov    $0x6c75,%eax
    1624:	mov    %rsp,%rsi
    1627:	mov    %rbx,(%rsp)
    162b:	movl   $0x61666564,0x10(%rsp)
    1633:	mov    %ax,0x14(%rsp)
    1638:	movb   $0x74,0x16(%rsp)
    163d:	movq   $0x7,0x8(%rsp)
    1646:	movb   $0x0,0x17(%rsp)
    164b:	call   10e0 <std::random_device::_M_init(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)@plt>
    1650:	mov    (%rsp),%rdi
    1654:	cmp    %rbx,%rdi
    1657:	je     1667 <std::random_device::random_device()+0x67>
    1659:	mov    0x10(%rsp),%rax
    165e:	lea    0x1(%rax),%rsi
    1662:	call   10b0 <operator delete(void*, unsigned long)@plt>
    1667:	mov    0x28(%rsp),%rax
    166c:	sub    %fs:0x28,%rax
    1675:	jne    167e <std::random_device::random_device()+0x7e>
    1677:	add    $0x38,%rsp
    167b:	pop    %rbx
    167c:	pop    %rbp
    167d:	ret    
    167e:	call   10c0 <__stack_chk_fail@plt>
    1683:	endbr64 
    1687:	mov    %rax,%rbp
    168a:	mov    (%rsp),%rdi
    168e:	cmp    %rbx,%rdi
    1691:	je     16ac <std::random_device::random_device()+0xac>
    1693:	mov    0x10(%rsp),%rax
    1698:	lea    0x1(%rax),%rsi
    169c:	vzeroupper 
    169f:	call   10b0 <operator delete(void*, unsigned long)@plt>
    16a4:	mov    %rbp,%rdi
    16a7:	call   10f0 <_Unwind_Resume@plt>
    16ac:	vzeroupper 
    16af:	jmp    16a4 <std::random_device::random_device()+0xa4>
    16b1:	cs nopw 0x0(%rax,%rax,1)
    16bb:	nopl   0x0(%rax,%rax,1)

00000000000016c0 <std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>::_M_gen_rand()>:
    16c0:	endbr64 
    16c4:	vmovdqa 0x954(%rip),%ymm3        # 2020 <_IO_stdin_used+0x20>
    16cc:	mov    %rdi,%rax
    16cf:	mov    %rdi,%rdx
    16d2:	vmovdqa 0x966(%rip),%ymm4        # 2040 <_IO_stdin_used+0x40>
    16da:	vmovdqa 0x97e(%rip),%ymm5        # 2060 <_IO_stdin_used+0x60>
    16e2:	vmovdqa 0x996(%rip),%ymm6        # 2080 <_IO_stdin_used+0x80>
    16ea:	lea    0x700(%rdi),%rcx
    16f1:	vpxor  %xmm7,%xmm7,%xmm7
    16f5:	nopl   (%rax)
    16f8:	vpand  0x8(%rdx),%ymm4,%ymm1
    16fd:	vpand  (%rdx),%ymm3,%ymm0
    1701:	add    $0x20,%rdx
    1705:	vpor   %ymm1,%ymm0,%ymm0
    1709:	vpsrlq $0x1,%ymm0,%ymm1
    170e:	vpand  %ymm5,%ymm0,%ymm0
    1712:	vpxor  0xc48(%rdx),%ymm1,%ymm1
    171a:	vpcmpeqq %ymm7,%ymm0,%ymm0
    171f:	vpxor  %ymm6,%ymm1,%ymm2
    1723:	vpblendvb %ymm0,%ymm1,%ymm2,%ymm0
    1729:	vmovdqu %ymm0,-0x20(%rdx)
    172e:	cmp    %rdx,%rcx
    1731:	jne    16f8 <std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>::_M_gen_rand()+0x38>
    1733:	vmovdqa 0x8e5(%rip),%xmm0        # 2020 <_IO_stdin_used+0x20>
    173b:	vmovdqa 0x8fd(%rip),%xmm1        # 2040 <_IO_stdin_used+0x40>
    1743:	vpxor  %xmm7,%xmm7,%xmm7
    1747:	vpand  0x708(%rax),%xmm1,%xmm1
    174f:	vpand  0x700(%rax),%xmm0,%xmm0
    1757:	mov    0x710(%rax),%rdx
    175e:	mov    0x718(%rax),%rcx
    1765:	vpor   %xmm1,%xmm0,%xmm0
    1769:	vpsrlq $0x1,%xmm0,%xmm1
    176e:	vpand  0x8ea(%rip),%xmm0,%xmm0        # 2060 <_IO_stdin_used+0x60>
    1776:	and    $0x7fffffff,%ecx
    177c:	and    $0xffffffff80000000,%rdx
    1783:	vpxor  0x1368(%rax),%xmm1,%xmm1
    178b:	or     %rcx,%rdx
    178e:	vpxor  0x8ea(%rip),%xmm1,%xmm2        # 2080 <_IO_stdin_used+0x80>
    1796:	vpcmpeqq %xmm7,%xmm0,%xmm0
    179b:	mov    %rdx,%rcx
    179e:	shr    %rcx
    17a1:	xor    0x1378(%rax),%rcx
    17a8:	and    $0x1,%edx
    17ab:	vpblendvb %xmm0,%xmm1,%xmm2,%xmm0
    17b1:	vmovdqu %xmm0,0x700(%rax)
    17b9:	je     17c3 <std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>::_M_gen_rand()+0x103>
    17bb:	mov    $0x9908b0df,%edx
    17c0:	xor    %rdx,%rcx
    17c3:	mov    %rcx,0x710(%rax)
    17ca:	lea    0x718(%rax),%rdx
    17d1:	vpxor  %xmm2,%xmm2,%xmm2
    17d5:	lea    0x1378(%rax),%rcx
    17dc:	vpand  0x8(%rdx),%ymm4,%ymm1
    17e1:	vpand  (%rdx),%ymm3,%ymm0
    17e5:	add    $0x20,%rdx
    17e9:	vpor   %ymm1,%ymm0,%ymm0
    17ed:	vpsrlq $0x1,%ymm0,%ymm1
    17f2:	vpand  %ymm5,%ymm0,%ymm0
    17f6:	vpxor  -0x738(%rdx),%ymm1,%ymm1
    17fe:	vpcmpeqq %ymm2,%ymm0,%ymm0
    1803:	vpxor  %ymm6,%ymm1,%ymm7
    1807:	vpblendvb %ymm0,%ymm1,%ymm7,%ymm0
    180d:	vmovdqu %ymm0,-0x20(%rdx)
    1812:	cmp    %rcx,%rdx
    1815:	jne    17dc <std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>::_M_gen_rand()+0x11c>
    1817:	mov    0x1378(%rax),%rdx
    181e:	mov    (%rax),%rcx
    1821:	and    $0xffffffff80000000,%rdx
    1828:	and    $0x7fffffff,%ecx
    182e:	or     %rcx,%rdx
    1831:	mov    %rdx,%rcx
    1834:	shr    %rcx
    1837:	xor    0xc60(%rax),%rcx
    183e:	and    $0x1,%edx
    1841:	je     184b <std::mersenne_twister_engine<unsigned long, 32ul, 624ul, 397ul, 31ul, 2567483615ul, 11ul, 4294967295ul, 7ul, 2636928640ul, 15ul, 4022730752ul, 18ul, 1812433253ul>::_M_gen_rand()+0x18b>
    1843:	mov    $0x9908b0df,%edx
    1848:	xor    %rdx,%rcx
    184b:	mov    %rcx,0x1378(%rax)
    1852:	movq   $0x0,0x1380(%rax)
    185d:	vzeroupper 
    1860:	ret    

Disassembly of section .fini:

0000000000001864 <_fini>:
    1864:	endbr64 
    1868:	sub    $0x8,%rsp
    186c:	add    $0x8,%rsp
    1870:	ret    
