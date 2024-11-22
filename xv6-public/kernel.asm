
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 b5 19 80       	mov    $0x8019b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 90 30 10 80       	mov    $0x80103090,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 80 7a 10 80       	push   $0x80107a80
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 e5 44 00 00       	call   80104540 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 7a 10 80       	push   $0x80107a87
80100097:	50                   	push   %eax
80100098:	e8 73 43 00 00       	call   80104410 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 27 46 00 00       	call   80104710 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 49 45 00 00       	call   801046b0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 42 00 00       	call   80104450 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 5f 21 00 00       	call   801022f0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 8e 7a 10 80       	push   $0x80107a8e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 2d 43 00 00       	call   801044f0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 17 21 00 00       	jmp    801022f0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 9f 7a 10 80       	push   $0x80107a9f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ec 42 00 00       	call   801044f0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 9c 42 00 00       	call   801044b0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 f0 44 00 00       	call   80104710 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 3f 44 00 00       	jmp    801046b0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 a6 7a 10 80       	push   $0x80107aa6
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 d7 15 00 00       	call   80101870 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 6b 44 00 00       	call   80104710 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 de 3e 00 00       	call   801041b0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 d9 36 00 00       	call   801039c0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 b5 43 00 00       	call   801046b0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 8c 14 00 00       	call   80101790 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 5f 43 00 00       	call   801046b0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 36 14 00 00       	call   80101790 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 82 25 00 00       	call   80102920 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 ad 7a 10 80       	push   $0x80107aad
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 1f 82 10 80 	movl   $0x8010821f,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 93 41 00 00       	call   80104560 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 c1 7a 10 80       	push   $0x80107ac1
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 b1 5d 00 00       	call   801061d0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 c6 5c 00 00       	call   801061d0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 ba 5c 00 00       	call   801061d0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 ae 5c 00 00       	call   801061d0 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 1a 43 00 00       	call   80104870 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 65 42 00 00       	call   801047d0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 c5 7a 10 80       	push   $0x80107ac5
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 cc 12 00 00       	call   80101870 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 60 41 00 00       	call   80104710 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 c7 40 00 00       	call   801046b0 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 9e 11 00 00       	call   80101790 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 f0 7a 10 80 	movzbl -0x7fef8510(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ff 10 80       	push   $0x8010ff20
801007e8:	e8 23 3f 00 00       	call   80104710 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf d8 7a 10 80       	mov    $0x80107ad8,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 50 3e 00 00       	call   801046b0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 df 7a 10 80       	push   $0x80107adf
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ff 10 80       	push   $0x8010ff20
80100893:	e8 78 3e 00 00       	call   80104710 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100945:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010096c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100985:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100999:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b7:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ff 10 80       	push   $0x8010ff20
801009d0:	e8 db 3c 00 00       	call   801046b0 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 3d 39 00 00       	jmp    80104350 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a3f:	68 00 ff 10 80       	push   $0x8010ff00
80100a44:	e8 27 38 00 00       	call   80104270 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 e8 7a 10 80       	push   $0x80107ae8
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 cb 3a 00 00       	call   80104540 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 f2 19 00 00       	call   80102490 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 ff 2e 00 00       	call   801039c0 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 c4 22 00 00       	call   80102d90 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 d9 15 00 00       	call   801020b0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 12 03 00 00    	je     80100df4 <exec+0x344>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 a3 0c 00 00       	call   80101790 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 a2 0f 00 00       	call   80101aa0 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 11 0f 00 00       	call   80101a20 <iunlockput>
    end_op();
80100b0f:	e8 ec 22 00 00       	call   80102e00 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 b7 68 00 00       	call   801073f0 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 bc 02 00 00    	je     80100e13 <exec+0x363>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 98 00 00 00       	jmp    80100c00 <exec+0x150>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 76                	jne    80100bef <exec+0x13f>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 91 00 00 00    	jb     80100c1c <exec+0x16c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	0f 82 85 00 00 00    	jb     80100c1c <exec+0x16c>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b97:	83 ec 04             	sub    $0x4,%esp
80100b9a:	50                   	push   %eax
80100b9b:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100ba1:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba7:	e8 64 66 00 00       	call   80107210 <allocuvm>
80100bac:	83 c4 10             	add    $0x10,%esp
80100baf:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb5:	85 c0                	test   %eax,%eax
80100bb7:	74 63                	je     80100c1c <exec+0x16c>
    if(ph.vaddr % PGSIZE != 0)
80100bb9:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc4:	75 56                	jne    80100c1c <exec+0x16c>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz, ph.flags) < 0)
80100bc6:	83 ec 08             	sub    $0x8,%esp
80100bc9:	ff b5 1c ff ff ff    	push   -0xe4(%ebp)
80100bcf:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bd5:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bdb:	53                   	push   %ebx
80100bdc:	50                   	push   %eax
80100bdd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100be3:	e8 38 65 00 00       	call   80107120 <loaduvm>
80100be8:	83 c4 20             	add    $0x20,%esp
80100beb:	85 c0                	test   %eax,%eax
80100bed:	78 2d                	js     80100c1c <exec+0x16c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bef:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bf6:	83 c7 01             	add    $0x1,%edi
80100bf9:	83 c6 20             	add    $0x20,%esi
80100bfc:	39 f8                	cmp    %edi,%eax
80100bfe:	7e 38                	jle    80100c38 <exec+0x188>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c00:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c06:	6a 20                	push   $0x20
80100c08:	56                   	push   %esi
80100c09:	50                   	push   %eax
80100c0a:	53                   	push   %ebx
80100c0b:	e8 90 0e 00 00       	call   80101aa0 <readi>
80100c10:	83 c4 10             	add    $0x10,%esp
80100c13:	83 f8 20             	cmp    $0x20,%eax
80100c16:	0f 84 54 ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c1c:	83 ec 0c             	sub    $0xc,%esp
80100c1f:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c25:	e8 46 67 00 00       	call   80107370 <freevm>
  if(ip){
80100c2a:	83 c4 10             	add    $0x10,%esp
80100c2d:	e9 d4 fe ff ff       	jmp    80100b06 <exec+0x56>
80100c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  sz = PGROUNDUP(sz);
80100c38:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c3e:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c44:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c4a:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c50:	83 ec 0c             	sub    $0xc,%esp
80100c53:	53                   	push   %ebx
80100c54:	e8 c7 0d 00 00       	call   80101a20 <iunlockput>
  end_op();
80100c59:	e8 a2 21 00 00       	call   80102e00 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c5e:	83 c4 0c             	add    $0xc,%esp
80100c61:	56                   	push   %esi
80100c62:	57                   	push   %edi
80100c63:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c69:	57                   	push   %edi
80100c6a:	e8 a1 65 00 00       	call   80107210 <allocuvm>
80100c6f:	83 c4 10             	add    $0x10,%esp
80100c72:	89 c6                	mov    %eax,%esi
80100c74:	85 c0                	test   %eax,%eax
80100c76:	0f 84 94 00 00 00    	je     80100d10 <exec+0x260>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7c:	83 ec 08             	sub    $0x8,%esp
80100c7f:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c85:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c87:	50                   	push   %eax
80100c88:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c89:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c8b:	e8 00 68 00 00       	call   80107490 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c90:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c93:	83 c4 10             	add    $0x10,%esp
80100c96:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c9c:	8b 00                	mov    (%eax),%eax
80100c9e:	85 c0                	test   %eax,%eax
80100ca0:	0f 84 8b 00 00 00    	je     80100d31 <exec+0x281>
80100ca6:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100cac:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100cb2:	eb 23                	jmp    80100cd7 <exec+0x227>
80100cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cbb:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cc2:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cc5:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100ccb:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cce:	85 c0                	test   %eax,%eax
80100cd0:	74 59                	je     80100d2b <exec+0x27b>
    if(argc >= MAXARG)
80100cd2:	83 ff 20             	cmp    $0x20,%edi
80100cd5:	74 39                	je     80100d10 <exec+0x260>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cd7:	83 ec 0c             	sub    $0xc,%esp
80100cda:	50                   	push   %eax
80100cdb:	e8 f0 3c 00 00       	call   801049d0 <strlen>
80100ce0:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce2:	58                   	pop    %eax
80100ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce6:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce9:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cec:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cef:	e8 dc 3c 00 00       	call   801049d0 <strlen>
80100cf4:	83 c0 01             	add    $0x1,%eax
80100cf7:	50                   	push   %eax
80100cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cfb:	ff 34 b8             	push   (%eax,%edi,4)
80100cfe:	53                   	push   %ebx
80100cff:	56                   	push   %esi
80100d00:	e8 0b 69 00 00       	call   80107610 <copyout>
80100d05:	83 c4 20             	add    $0x20,%esp
80100d08:	85 c0                	test   %eax,%eax
80100d0a:	79 ac                	jns    80100cb8 <exec+0x208>
80100d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d10:	83 ec 0c             	sub    $0xc,%esp
80100d13:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d19:	e8 52 66 00 00       	call   80107370 <freevm>
80100d1e:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d26:	e9 f1 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d2b:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d31:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d38:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d3a:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d41:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d45:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d47:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d4a:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d50:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d52:	50                   	push   %eax
80100d53:	52                   	push   %edx
80100d54:	53                   	push   %ebx
80100d55:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d5b:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d62:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d65:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d6b:	e8 a0 68 00 00       	call   80107610 <copyout>
80100d70:	83 c4 10             	add    $0x10,%esp
80100d73:	85 c0                	test   %eax,%eax
80100d75:	78 99                	js     80100d10 <exec+0x260>
  for(last=s=path; *s; s++)
80100d77:	8b 45 08             	mov    0x8(%ebp),%eax
80100d7a:	8b 55 08             	mov    0x8(%ebp),%edx
80100d7d:	0f b6 00             	movzbl (%eax),%eax
80100d80:	84 c0                	test   %al,%al
80100d82:	74 1b                	je     80100d9f <exec+0x2ef>
80100d84:	89 d1                	mov    %edx,%ecx
80100d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d8d:	8d 76 00             	lea    0x0(%esi),%esi
      last = s+1;
80100d90:	83 c1 01             	add    $0x1,%ecx
80100d93:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d95:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d98:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d9b:	84 c0                	test   %al,%al
80100d9d:	75 f1                	jne    80100d90 <exec+0x2e0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d9f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100da5:	83 ec 04             	sub    $0x4,%esp
80100da8:	6a 10                	push   $0x10
80100daa:	89 f8                	mov    %edi,%eax
80100dac:	52                   	push   %edx
80100dad:	83 c0 6c             	add    $0x6c,%eax
80100db0:	50                   	push   %eax
80100db1:	e8 da 3b 00 00       	call   80104990 <safestrcpy>
  curproc->pgdir = pgdir;
80100db6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dbc:	89 f8                	mov    %edi,%eax
80100dbe:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100dc1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100dc3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100dc6:	89 c1                	mov    %eax,%ecx
80100dc8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dce:	8b 40 18             	mov    0x18(%eax),%eax
80100dd1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dd4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dd7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dda:	89 0c 24             	mov    %ecx,(%esp)
80100ddd:	e8 ae 61 00 00       	call   80106f90 <switchuvm>
  freevm(oldpgdir);
80100de2:	89 3c 24             	mov    %edi,(%esp)
80100de5:	e8 86 65 00 00       	call   80107370 <freevm>
  return 0;
80100dea:	83 c4 10             	add    $0x10,%esp
80100ded:	31 c0                	xor    %eax,%eax
80100def:	e9 28 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100df4:	e8 07 20 00 00       	call   80102e00 <end_op>
    cprintf("exec: fail\n");
80100df9:	83 ec 0c             	sub    $0xc,%esp
80100dfc:	68 01 7b 10 80       	push   $0x80107b01
80100e01:	e8 9a f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100e06:	83 c4 10             	add    $0x10,%esp
80100e09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e0e:	e9 09 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e13:	be 00 20 00 00       	mov    $0x2000,%esi
80100e18:	31 ff                	xor    %edi,%edi
80100e1a:	e9 31 fe ff ff       	jmp    80100c50 <exec+0x1a0>
80100e1f:	90                   	nop

80100e20 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e26:	68 0d 7b 10 80       	push   $0x80107b0d
80100e2b:	68 60 ff 10 80       	push   $0x8010ff60
80100e30:	e8 0b 37 00 00       	call   80104540 <initlock>
}
80100e35:	83 c4 10             	add    $0x10,%esp
80100e38:	c9                   	leave  
80100e39:	c3                   	ret    
80100e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e40 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e44:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e49:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e4c:	68 60 ff 10 80       	push   $0x8010ff60
80100e51:	e8 ba 38 00 00       	call   80104710 <acquire>
80100e56:	83 c4 10             	add    $0x10,%esp
80100e59:	eb 10                	jmp    80100e6b <filealloc+0x2b>
80100e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e5f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e60:	83 c3 18             	add    $0x18,%ebx
80100e63:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e69:	74 25                	je     80100e90 <filealloc+0x50>
    if(f->ref == 0){
80100e6b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e6e:	85 c0                	test   %eax,%eax
80100e70:	75 ee                	jne    80100e60 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e72:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e75:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e7c:	68 60 ff 10 80       	push   $0x8010ff60
80100e81:	e8 2a 38 00 00       	call   801046b0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e86:	89 d8                	mov    %ebx,%eax
      return f;
80100e88:	83 c4 10             	add    $0x10,%esp
}
80100e8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e8e:	c9                   	leave  
80100e8f:	c3                   	ret    
  release(&ftable.lock);
80100e90:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e93:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e95:	68 60 ff 10 80       	push   $0x8010ff60
80100e9a:	e8 11 38 00 00       	call   801046b0 <release>
}
80100e9f:	89 d8                	mov    %ebx,%eax
  return 0;
80100ea1:	83 c4 10             	add    $0x10,%esp
}
80100ea4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea7:	c9                   	leave  
80100ea8:	c3                   	ret    
80100ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100eb0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100eb0:	55                   	push   %ebp
80100eb1:	89 e5                	mov    %esp,%ebp
80100eb3:	53                   	push   %ebx
80100eb4:	83 ec 10             	sub    $0x10,%esp
80100eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eba:	68 60 ff 10 80       	push   $0x8010ff60
80100ebf:	e8 4c 38 00 00       	call   80104710 <acquire>
  if(f->ref < 1)
80100ec4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ec7:	83 c4 10             	add    $0x10,%esp
80100eca:	85 c0                	test   %eax,%eax
80100ecc:	7e 1a                	jle    80100ee8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ece:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ed1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ed4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ed7:	68 60 ff 10 80       	push   $0x8010ff60
80100edc:	e8 cf 37 00 00       	call   801046b0 <release>
  return f;
}
80100ee1:	89 d8                	mov    %ebx,%eax
80100ee3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee6:	c9                   	leave  
80100ee7:	c3                   	ret    
    panic("filedup");
80100ee8:	83 ec 0c             	sub    $0xc,%esp
80100eeb:	68 14 7b 10 80       	push   $0x80107b14
80100ef0:	e8 8b f4 ff ff       	call   80100380 <panic>
80100ef5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	57                   	push   %edi
80100f04:	56                   	push   %esi
80100f05:	53                   	push   %ebx
80100f06:	83 ec 28             	sub    $0x28,%esp
80100f09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f0c:	68 60 ff 10 80       	push   $0x8010ff60
80100f11:	e8 fa 37 00 00       	call   80104710 <acquire>
  if(f->ref < 1)
80100f16:	8b 53 04             	mov    0x4(%ebx),%edx
80100f19:	83 c4 10             	add    $0x10,%esp
80100f1c:	85 d2                	test   %edx,%edx
80100f1e:	0f 8e a5 00 00 00    	jle    80100fc9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f24:	83 ea 01             	sub    $0x1,%edx
80100f27:	89 53 04             	mov    %edx,0x4(%ebx)
80100f2a:	75 44                	jne    80100f70 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f2c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f30:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f33:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f35:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f3b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f3e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f41:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f44:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f49:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f4c:	e8 5f 37 00 00       	call   801046b0 <release>

  if(ff.type == FD_PIPE)
80100f51:	83 c4 10             	add    $0x10,%esp
80100f54:	83 ff 01             	cmp    $0x1,%edi
80100f57:	74 57                	je     80100fb0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f59:	83 ff 02             	cmp    $0x2,%edi
80100f5c:	74 2a                	je     80100f88 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f61:	5b                   	pop    %ebx
80100f62:	5e                   	pop    %esi
80100f63:	5f                   	pop    %edi
80100f64:	5d                   	pop    %ebp
80100f65:	c3                   	ret    
80100f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f70:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f7a:	5b                   	pop    %ebx
80100f7b:	5e                   	pop    %esi
80100f7c:	5f                   	pop    %edi
80100f7d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f7e:	e9 2d 37 00 00       	jmp    801046b0 <release>
80100f83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f87:	90                   	nop
    begin_op();
80100f88:	e8 03 1e 00 00       	call   80102d90 <begin_op>
    iput(ff.ip);
80100f8d:	83 ec 0c             	sub    $0xc,%esp
80100f90:	ff 75 e0             	push   -0x20(%ebp)
80100f93:	e8 28 09 00 00       	call   801018c0 <iput>
    end_op();
80100f98:	83 c4 10             	add    $0x10,%esp
}
80100f9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f9e:	5b                   	pop    %ebx
80100f9f:	5e                   	pop    %esi
80100fa0:	5f                   	pop    %edi
80100fa1:	5d                   	pop    %ebp
    end_op();
80100fa2:	e9 59 1e 00 00       	jmp    80102e00 <end_op>
80100fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fae:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fb0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fb4:	83 ec 08             	sub    $0x8,%esp
80100fb7:	53                   	push   %ebx
80100fb8:	56                   	push   %esi
80100fb9:	e8 a2 25 00 00       	call   80103560 <pipeclose>
80100fbe:	83 c4 10             	add    $0x10,%esp
}
80100fc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc4:	5b                   	pop    %ebx
80100fc5:	5e                   	pop    %esi
80100fc6:	5f                   	pop    %edi
80100fc7:	5d                   	pop    %ebp
80100fc8:	c3                   	ret    
    panic("fileclose");
80100fc9:	83 ec 0c             	sub    $0xc,%esp
80100fcc:	68 1c 7b 10 80       	push   $0x80107b1c
80100fd1:	e8 aa f3 ff ff       	call   80100380 <panic>
80100fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fdd:	8d 76 00             	lea    0x0(%esi),%esi

80100fe0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	53                   	push   %ebx
80100fe4:	83 ec 04             	sub    $0x4,%esp
80100fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fea:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fed:	75 31                	jne    80101020 <filestat+0x40>
    ilock(f->ip);
80100fef:	83 ec 0c             	sub    $0xc,%esp
80100ff2:	ff 73 10             	push   0x10(%ebx)
80100ff5:	e8 96 07 00 00       	call   80101790 <ilock>
    stati(f->ip, st);
80100ffa:	58                   	pop    %eax
80100ffb:	5a                   	pop    %edx
80100ffc:	ff 75 0c             	push   0xc(%ebp)
80100fff:	ff 73 10             	push   0x10(%ebx)
80101002:	e8 69 0a 00 00       	call   80101a70 <stati>
    iunlock(f->ip);
80101007:	59                   	pop    %ecx
80101008:	ff 73 10             	push   0x10(%ebx)
8010100b:	e8 60 08 00 00       	call   80101870 <iunlock>
    return 0;
  }
  return -1;
}
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101013:	83 c4 10             	add    $0x10,%esp
80101016:	31 c0                	xor    %eax,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101023:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101028:	c9                   	leave  
80101029:	c3                   	ret    
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101030 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101030:	55                   	push   %ebp
80101031:	89 e5                	mov    %esp,%ebp
80101033:	57                   	push   %edi
80101034:	56                   	push   %esi
80101035:	53                   	push   %ebx
80101036:	83 ec 0c             	sub    $0xc,%esp
80101039:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010103c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010103f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101042:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101046:	74 60                	je     801010a8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101048:	8b 03                	mov    (%ebx),%eax
8010104a:	83 f8 01             	cmp    $0x1,%eax
8010104d:	74 41                	je     80101090 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010104f:	83 f8 02             	cmp    $0x2,%eax
80101052:	75 5b                	jne    801010af <fileread+0x7f>
    ilock(f->ip);
80101054:	83 ec 0c             	sub    $0xc,%esp
80101057:	ff 73 10             	push   0x10(%ebx)
8010105a:	e8 31 07 00 00       	call   80101790 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010105f:	57                   	push   %edi
80101060:	ff 73 14             	push   0x14(%ebx)
80101063:	56                   	push   %esi
80101064:	ff 73 10             	push   0x10(%ebx)
80101067:	e8 34 0a 00 00       	call   80101aa0 <readi>
8010106c:	83 c4 20             	add    $0x20,%esp
8010106f:	89 c6                	mov    %eax,%esi
80101071:	85 c0                	test   %eax,%eax
80101073:	7e 03                	jle    80101078 <fileread+0x48>
      f->off += r;
80101075:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101078:	83 ec 0c             	sub    $0xc,%esp
8010107b:	ff 73 10             	push   0x10(%ebx)
8010107e:	e8 ed 07 00 00       	call   80101870 <iunlock>
    return r;
80101083:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	89 f0                	mov    %esi,%eax
8010108b:	5b                   	pop    %ebx
8010108c:	5e                   	pop    %esi
8010108d:	5f                   	pop    %edi
8010108e:	5d                   	pop    %ebp
8010108f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101090:	8b 43 0c             	mov    0xc(%ebx),%eax
80101093:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101099:	5b                   	pop    %ebx
8010109a:	5e                   	pop    %esi
8010109b:	5f                   	pop    %edi
8010109c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010109d:	e9 5e 26 00 00       	jmp    80103700 <piperead>
801010a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010ad:	eb d7                	jmp    80101086 <fileread+0x56>
  panic("fileread");
801010af:	83 ec 0c             	sub    $0xc,%esp
801010b2:	68 26 7b 10 80       	push   $0x80107b26
801010b7:	e8 c4 f2 ff ff       	call   80100380 <panic>
801010bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010c0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010c0:	55                   	push   %ebp
801010c1:	89 e5                	mov    %esp,%ebp
801010c3:	57                   	push   %edi
801010c4:	56                   	push   %esi
801010c5:	53                   	push   %ebx
801010c6:	83 ec 1c             	sub    $0x1c,%esp
801010c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010d2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010d5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010dc:	0f 84 bd 00 00 00    	je     8010119f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010e2:	8b 03                	mov    (%ebx),%eax
801010e4:	83 f8 01             	cmp    $0x1,%eax
801010e7:	0f 84 bf 00 00 00    	je     801011ac <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010ed:	83 f8 02             	cmp    $0x2,%eax
801010f0:	0f 85 c8 00 00 00    	jne    801011be <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010f9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010fb:	85 c0                	test   %eax,%eax
801010fd:	7f 30                	jg     8010112f <filewrite+0x6f>
801010ff:	e9 94 00 00 00       	jmp    80101198 <filewrite+0xd8>
80101104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101108:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010110b:	83 ec 0c             	sub    $0xc,%esp
8010110e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101111:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101114:	e8 57 07 00 00       	call   80101870 <iunlock>
      end_op();
80101119:	e8 e2 1c 00 00       	call   80102e00 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010111e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101121:	83 c4 10             	add    $0x10,%esp
80101124:	39 c7                	cmp    %eax,%edi
80101126:	75 5c                	jne    80101184 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101128:	01 fe                	add    %edi,%esi
    while(i < n){
8010112a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010112d:	7e 69                	jle    80101198 <filewrite+0xd8>
      int n1 = n - i;
8010112f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101132:	b8 00 06 00 00       	mov    $0x600,%eax
80101137:	29 f7                	sub    %esi,%edi
80101139:	39 c7                	cmp    %eax,%edi
8010113b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010113e:	e8 4d 1c 00 00       	call   80102d90 <begin_op>
      ilock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 73 10             	push   0x10(%ebx)
80101149:	e8 42 06 00 00       	call   80101790 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010114e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101151:	57                   	push   %edi
80101152:	ff 73 14             	push   0x14(%ebx)
80101155:	01 f0                	add    %esi,%eax
80101157:	50                   	push   %eax
80101158:	ff 73 10             	push   0x10(%ebx)
8010115b:	e8 40 0a 00 00       	call   80101ba0 <writei>
80101160:	83 c4 20             	add    $0x20,%esp
80101163:	85 c0                	test   %eax,%eax
80101165:	7f a1                	jg     80101108 <filewrite+0x48>
      iunlock(f->ip);
80101167:	83 ec 0c             	sub    $0xc,%esp
8010116a:	ff 73 10             	push   0x10(%ebx)
8010116d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101170:	e8 fb 06 00 00       	call   80101870 <iunlock>
      end_op();
80101175:	e8 86 1c 00 00       	call   80102e00 <end_op>
      if(r < 0)
8010117a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010117d:	83 c4 10             	add    $0x10,%esp
80101180:	85 c0                	test   %eax,%eax
80101182:	75 1b                	jne    8010119f <filewrite+0xdf>
        panic("short filewrite");
80101184:	83 ec 0c             	sub    $0xc,%esp
80101187:	68 2f 7b 10 80       	push   $0x80107b2f
8010118c:	e8 ef f1 ff ff       	call   80100380 <panic>
80101191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101198:	89 f0                	mov    %esi,%eax
8010119a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010119d:	74 05                	je     801011a4 <filewrite+0xe4>
8010119f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801011a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a7:	5b                   	pop    %ebx
801011a8:	5e                   	pop    %esi
801011a9:	5f                   	pop    %edi
801011aa:	5d                   	pop    %ebp
801011ab:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801011ac:	8b 43 0c             	mov    0xc(%ebx),%eax
801011af:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b5:	5b                   	pop    %ebx
801011b6:	5e                   	pop    %esi
801011b7:	5f                   	pop    %edi
801011b8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011b9:	e9 42 24 00 00       	jmp    80103600 <pipewrite>
  panic("filewrite");
801011be:	83 ec 0c             	sub    $0xc,%esp
801011c1:	68 35 7b 10 80       	push   $0x80107b35
801011c6:	e8 b5 f1 ff ff       	call   80100380 <panic>
801011cb:	66 90                	xchg   %ax,%ax
801011cd:	66 90                	xchg   %ax,%ax
801011cf:	90                   	nop

801011d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011d0:	55                   	push   %ebp
801011d1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011d3:	89 d0                	mov    %edx,%eax
801011d5:	c1 e8 0c             	shr    $0xc,%eax
801011d8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801011de:	89 e5                	mov    %esp,%ebp
801011e0:	56                   	push   %esi
801011e1:	53                   	push   %ebx
801011e2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011e4:	83 ec 08             	sub    $0x8,%esp
801011e7:	50                   	push   %eax
801011e8:	51                   	push   %ecx
801011e9:	e8 e2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ee:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011f0:	c1 fb 03             	sar    $0x3,%ebx
801011f3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011f6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011f8:	83 e1 07             	and    $0x7,%ecx
801011fb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101200:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101206:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101208:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010120d:	85 c1                	test   %eax,%ecx
8010120f:	74 23                	je     80101234 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101211:	f7 d0                	not    %eax
  log_write(bp);
80101213:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101216:	21 c8                	and    %ecx,%eax
80101218:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010121c:	56                   	push   %esi
8010121d:	e8 4e 1d 00 00       	call   80102f70 <log_write>
  brelse(bp);
80101222:	89 34 24             	mov    %esi,(%esp)
80101225:	e8 c6 ef ff ff       	call   801001f0 <brelse>
}
8010122a:	83 c4 10             	add    $0x10,%esp
8010122d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101230:	5b                   	pop    %ebx
80101231:	5e                   	pop    %esi
80101232:	5d                   	pop    %ebp
80101233:	c3                   	ret    
    panic("freeing free block");
80101234:	83 ec 0c             	sub    $0xc,%esp
80101237:	68 3f 7b 10 80       	push   $0x80107b3f
8010123c:	e8 3f f1 ff ff       	call   80100380 <panic>
80101241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010124f:	90                   	nop

80101250 <balloc>:
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	57                   	push   %edi
80101254:	56                   	push   %esi
80101255:	53                   	push   %ebx
80101256:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101259:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010125f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101262:	85 c9                	test   %ecx,%ecx
80101264:	0f 84 87 00 00 00    	je     801012f1 <balloc+0xa1>
8010126a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101271:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101274:	83 ec 08             	sub    $0x8,%esp
80101277:	89 f0                	mov    %esi,%eax
80101279:	c1 f8 0c             	sar    $0xc,%eax
8010127c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101282:	50                   	push   %eax
80101283:	ff 75 d8             	push   -0x28(%ebp)
80101286:	e8 45 ee ff ff       	call   801000d0 <bread>
8010128b:	83 c4 10             	add    $0x10,%esp
8010128e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101291:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101296:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101299:	31 c0                	xor    %eax,%eax
8010129b:	eb 2f                	jmp    801012cc <balloc+0x7c>
8010129d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012a0:	89 c1                	mov    %eax,%ecx
801012a2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012aa:	83 e1 07             	and    $0x7,%ecx
801012ad:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012af:	89 c1                	mov    %eax,%ecx
801012b1:	c1 f9 03             	sar    $0x3,%ecx
801012b4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012b9:	89 fa                	mov    %edi,%edx
801012bb:	85 df                	test   %ebx,%edi
801012bd:	74 41                	je     80101300 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012bf:	83 c0 01             	add    $0x1,%eax
801012c2:	83 c6 01             	add    $0x1,%esi
801012c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ca:	74 05                	je     801012d1 <balloc+0x81>
801012cc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012cf:	77 cf                	ja     801012a0 <balloc+0x50>
    brelse(bp);
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	ff 75 e4             	push   -0x1c(%ebp)
801012d7:	e8 14 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012dc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012e3:	83 c4 10             	add    $0x10,%esp
801012e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012e9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801012ef:	77 80                	ja     80101271 <balloc+0x21>
  panic("balloc: out of blocks");
801012f1:	83 ec 0c             	sub    $0xc,%esp
801012f4:	68 52 7b 10 80       	push   $0x80107b52
801012f9:	e8 82 f0 ff ff       	call   80100380 <panic>
801012fe:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101300:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101303:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101306:	09 da                	or     %ebx,%edx
80101308:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010130c:	57                   	push   %edi
8010130d:	e8 5e 1c 00 00       	call   80102f70 <log_write>
        brelse(bp);
80101312:	89 3c 24             	mov    %edi,(%esp)
80101315:	e8 d6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010131a:	58                   	pop    %eax
8010131b:	5a                   	pop    %edx
8010131c:	56                   	push   %esi
8010131d:	ff 75 d8             	push   -0x28(%ebp)
80101320:	e8 ab ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101325:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101328:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010132a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010132d:	68 00 02 00 00       	push   $0x200
80101332:	6a 00                	push   $0x0
80101334:	50                   	push   %eax
80101335:	e8 96 34 00 00       	call   801047d0 <memset>
  log_write(bp);
8010133a:	89 1c 24             	mov    %ebx,(%esp)
8010133d:	e8 2e 1c 00 00       	call   80102f70 <log_write>
  brelse(bp);
80101342:	89 1c 24             	mov    %ebx,(%esp)
80101345:	e8 a6 ee ff ff       	call   801001f0 <brelse>
}
8010134a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010134d:	89 f0                	mov    %esi,%eax
8010134f:	5b                   	pop    %ebx
80101350:	5e                   	pop    %esi
80101351:	5f                   	pop    %edi
80101352:	5d                   	pop    %ebp
80101353:	c3                   	ret    
80101354:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010135b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010135f:	90                   	nop

80101360 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	89 c7                	mov    %eax,%edi
80101366:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101367:	31 f6                	xor    %esi,%esi
{
80101369:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010136f:	83 ec 28             	sub    $0x28,%esp
80101372:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101375:	68 60 09 11 80       	push   $0x80110960
8010137a:	e8 91 33 00 00       	call   80104710 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101382:	83 c4 10             	add    $0x10,%esp
80101385:	eb 1b                	jmp    801013a2 <iget+0x42>
80101387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010138e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101390:	39 3b                	cmp    %edi,(%ebx)
80101392:	74 6c                	je     80101400 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101394:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010139a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013a0:	73 26                	jae    801013c8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013a2:	8b 43 08             	mov    0x8(%ebx),%eax
801013a5:	85 c0                	test   %eax,%eax
801013a7:	7f e7                	jg     80101390 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013a9:	85 f6                	test   %esi,%esi
801013ab:	75 e7                	jne    80101394 <iget+0x34>
801013ad:	85 c0                	test   %eax,%eax
801013af:	75 76                	jne    80101427 <iget+0xc7>
801013b1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013b3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013b9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013bf:	72 e1                	jb     801013a2 <iget+0x42>
801013c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013c8:	85 f6                	test   %esi,%esi
801013ca:	74 79                	je     80101445 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013cc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013cf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013d1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013d4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013db:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013e2:	68 60 09 11 80       	push   $0x80110960
801013e7:	e8 c4 32 00 00       	call   801046b0 <release>

  return ip;
801013ec:	83 c4 10             	add    $0x10,%esp
}
801013ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013f2:	89 f0                	mov    %esi,%eax
801013f4:	5b                   	pop    %ebx
801013f5:	5e                   	pop    %esi
801013f6:	5f                   	pop    %edi
801013f7:	5d                   	pop    %ebp
801013f8:	c3                   	ret    
801013f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101400:	39 53 04             	cmp    %edx,0x4(%ebx)
80101403:	75 8f                	jne    80101394 <iget+0x34>
      release(&icache.lock);
80101405:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101408:	83 c0 01             	add    $0x1,%eax
      return ip;
8010140b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010140d:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101412:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101415:	e8 96 32 00 00       	call   801046b0 <release>
      return ip;
8010141a:	83 c4 10             	add    $0x10,%esp
}
8010141d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101420:	89 f0                	mov    %esi,%eax
80101422:	5b                   	pop    %ebx
80101423:	5e                   	pop    %esi
80101424:	5f                   	pop    %edi
80101425:	5d                   	pop    %ebp
80101426:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101427:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010142d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101433:	73 10                	jae    80101445 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101435:	8b 43 08             	mov    0x8(%ebx),%eax
80101438:	85 c0                	test   %eax,%eax
8010143a:	0f 8f 50 ff ff ff    	jg     80101390 <iget+0x30>
80101440:	e9 68 ff ff ff       	jmp    801013ad <iget+0x4d>
    panic("iget: no inodes");
80101445:	83 ec 0c             	sub    $0xc,%esp
80101448:	68 68 7b 10 80       	push   $0x80107b68
8010144d:	e8 2e ef ff ff       	call   80100380 <panic>
80101452:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101460 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	57                   	push   %edi
80101464:	56                   	push   %esi
80101465:	89 c6                	mov    %eax,%esi
80101467:	53                   	push   %ebx
80101468:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010146b:	83 fa 0b             	cmp    $0xb,%edx
8010146e:	0f 86 8c 00 00 00    	jbe    80101500 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101474:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101477:	83 fb 7f             	cmp    $0x7f,%ebx
8010147a:	0f 87 a2 00 00 00    	ja     80101522 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101480:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101486:	85 c0                	test   %eax,%eax
80101488:	74 5e                	je     801014e8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010148a:	83 ec 08             	sub    $0x8,%esp
8010148d:	50                   	push   %eax
8010148e:	ff 36                	push   (%esi)
80101490:	e8 3b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101495:	83 c4 10             	add    $0x10,%esp
80101498:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010149c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010149e:	8b 3b                	mov    (%ebx),%edi
801014a0:	85 ff                	test   %edi,%edi
801014a2:	74 1c                	je     801014c0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014a4:	83 ec 0c             	sub    $0xc,%esp
801014a7:	52                   	push   %edx
801014a8:	e8 43 ed ff ff       	call   801001f0 <brelse>
801014ad:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014b3:	89 f8                	mov    %edi,%eax
801014b5:	5b                   	pop    %ebx
801014b6:	5e                   	pop    %esi
801014b7:	5f                   	pop    %edi
801014b8:	5d                   	pop    %ebp
801014b9:	c3                   	ret    
801014ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014c3:	8b 06                	mov    (%esi),%eax
801014c5:	e8 86 fd ff ff       	call   80101250 <balloc>
      log_write(bp);
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014d0:	89 03                	mov    %eax,(%ebx)
801014d2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014d4:	52                   	push   %edx
801014d5:	e8 96 1a 00 00       	call   80102f70 <log_write>
801014da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014dd:	83 c4 10             	add    $0x10,%esp
801014e0:	eb c2                	jmp    801014a4 <bmap+0x44>
801014e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014e8:	8b 06                	mov    (%esi),%eax
801014ea:	e8 61 fd ff ff       	call   80101250 <balloc>
801014ef:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014f5:	eb 93                	jmp    8010148a <bmap+0x2a>
801014f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fe:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101500:	8d 5a 14             	lea    0x14(%edx),%ebx
80101503:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101507:	85 ff                	test   %edi,%edi
80101509:	75 a5                	jne    801014b0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010150b:	8b 00                	mov    (%eax),%eax
8010150d:	e8 3e fd ff ff       	call   80101250 <balloc>
80101512:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101516:	89 c7                	mov    %eax,%edi
}
80101518:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010151b:	5b                   	pop    %ebx
8010151c:	89 f8                	mov    %edi,%eax
8010151e:	5e                   	pop    %esi
8010151f:	5f                   	pop    %edi
80101520:	5d                   	pop    %ebp
80101521:	c3                   	ret    
  panic("bmap: out of range");
80101522:	83 ec 0c             	sub    $0xc,%esp
80101525:	68 78 7b 10 80       	push   $0x80107b78
8010152a:	e8 51 ee ff ff       	call   80100380 <panic>
8010152f:	90                   	nop

80101530 <readsb>:
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	56                   	push   %esi
80101534:	53                   	push   %ebx
80101535:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101538:	83 ec 08             	sub    $0x8,%esp
8010153b:	6a 01                	push   $0x1
8010153d:	ff 75 08             	push   0x8(%ebp)
80101540:	e8 8b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101545:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101548:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010154a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010154d:	6a 1c                	push   $0x1c
8010154f:	50                   	push   %eax
80101550:	56                   	push   %esi
80101551:	e8 1a 33 00 00       	call   80104870 <memmove>
  brelse(bp);
80101556:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101559:	83 c4 10             	add    $0x10,%esp
}
8010155c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010155f:	5b                   	pop    %ebx
80101560:	5e                   	pop    %esi
80101561:	5d                   	pop    %ebp
  brelse(bp);
80101562:	e9 89 ec ff ff       	jmp    801001f0 <brelse>
80101567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010156e:	66 90                	xchg   %ax,%ax

80101570 <iinit>:
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	53                   	push   %ebx
80101574:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101579:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010157c:	68 8b 7b 10 80       	push   $0x80107b8b
80101581:	68 60 09 11 80       	push   $0x80110960
80101586:	e8 b5 2f 00 00       	call   80104540 <initlock>
  for(i = 0; i < NINODE; i++) {
8010158b:	83 c4 10             	add    $0x10,%esp
8010158e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101590:	83 ec 08             	sub    $0x8,%esp
80101593:	68 92 7b 10 80       	push   $0x80107b92
80101598:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101599:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010159f:	e8 6c 2e 00 00       	call   80104410 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015a4:	83 c4 10             	add    $0x10,%esp
801015a7:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
801015ad:	75 e1                	jne    80101590 <iinit+0x20>
  bp = bread(dev, 1);
801015af:	83 ec 08             	sub    $0x8,%esp
801015b2:	6a 01                	push   $0x1
801015b4:	ff 75 08             	push   0x8(%ebp)
801015b7:	e8 14 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015bc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015bf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015c1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015c4:	6a 1c                	push   $0x1c
801015c6:	50                   	push   %eax
801015c7:	68 b4 25 11 80       	push   $0x801125b4
801015cc:	e8 9f 32 00 00       	call   80104870 <memmove>
  brelse(bp);
801015d1:	89 1c 24             	mov    %ebx,(%esp)
801015d4:	e8 17 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015d9:	ff 35 cc 25 11 80    	push   0x801125cc
801015df:	ff 35 c8 25 11 80    	push   0x801125c8
801015e5:	ff 35 c4 25 11 80    	push   0x801125c4
801015eb:	ff 35 c0 25 11 80    	push   0x801125c0
801015f1:	ff 35 bc 25 11 80    	push   0x801125bc
801015f7:	ff 35 b8 25 11 80    	push   0x801125b8
801015fd:	ff 35 b4 25 11 80    	push   0x801125b4
80101603:	68 f8 7b 10 80       	push   $0x80107bf8
80101608:	e8 93 f0 ff ff       	call   801006a0 <cprintf>
}
8010160d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101610:	83 c4 30             	add    $0x30,%esp
80101613:	c9                   	leave  
80101614:	c3                   	ret    
80101615:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010161c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101620 <ialloc>:
{
80101620:	55                   	push   %ebp
80101621:	89 e5                	mov    %esp,%ebp
80101623:	57                   	push   %edi
80101624:	56                   	push   %esi
80101625:	53                   	push   %ebx
80101626:	83 ec 1c             	sub    $0x1c,%esp
80101629:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010162c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101633:	8b 75 08             	mov    0x8(%ebp),%esi
80101636:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101639:	0f 86 91 00 00 00    	jbe    801016d0 <ialloc+0xb0>
8010163f:	bf 01 00 00 00       	mov    $0x1,%edi
80101644:	eb 21                	jmp    80101667 <ialloc+0x47>
80101646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010164d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101650:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101653:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101656:	53                   	push   %ebx
80101657:	e8 94 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010165c:	83 c4 10             	add    $0x10,%esp
8010165f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101665:	73 69                	jae    801016d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101667:	89 f8                	mov    %edi,%eax
80101669:	83 ec 08             	sub    $0x8,%esp
8010166c:	c1 e8 03             	shr    $0x3,%eax
8010166f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101675:	50                   	push   %eax
80101676:	56                   	push   %esi
80101677:	e8 54 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010167c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010167f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101681:	89 f8                	mov    %edi,%eax
80101683:	83 e0 07             	and    $0x7,%eax
80101686:	c1 e0 06             	shl    $0x6,%eax
80101689:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010168d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101691:	75 bd                	jne    80101650 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101693:	83 ec 04             	sub    $0x4,%esp
80101696:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101699:	6a 40                	push   $0x40
8010169b:	6a 00                	push   $0x0
8010169d:	51                   	push   %ecx
8010169e:	e8 2d 31 00 00       	call   801047d0 <memset>
      dip->type = type;
801016a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016ad:	89 1c 24             	mov    %ebx,(%esp)
801016b0:	e8 bb 18 00 00       	call   80102f70 <log_write>
      brelse(bp);
801016b5:	89 1c 24             	mov    %ebx,(%esp)
801016b8:	e8 33 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016bd:	83 c4 10             	add    $0x10,%esp
}
801016c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016c3:	89 fa                	mov    %edi,%edx
}
801016c5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016c6:	89 f0                	mov    %esi,%eax
}
801016c8:	5e                   	pop    %esi
801016c9:	5f                   	pop    %edi
801016ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801016cb:	e9 90 fc ff ff       	jmp    80101360 <iget>
  panic("ialloc: no inodes");
801016d0:	83 ec 0c             	sub    $0xc,%esp
801016d3:	68 98 7b 10 80       	push   $0x80107b98
801016d8:	e8 a3 ec ff ff       	call   80100380 <panic>
801016dd:	8d 76 00             	lea    0x0(%esi),%esi

801016e0 <iupdate>:
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	56                   	push   %esi
801016e4:	53                   	push   %ebx
801016e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016e8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016eb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ee:	83 ec 08             	sub    $0x8,%esp
801016f1:	c1 e8 03             	shr    $0x3,%eax
801016f4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016fa:	50                   	push   %eax
801016fb:	ff 73 a4             	push   -0x5c(%ebx)
801016fe:	e8 cd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101703:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101707:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010170a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010170c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010170f:	83 e0 07             	and    $0x7,%eax
80101712:	c1 e0 06             	shl    $0x6,%eax
80101715:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101719:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010171c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101720:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101723:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101727:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010172b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010172f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101733:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101737:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010173a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010173d:	6a 34                	push   $0x34
8010173f:	53                   	push   %ebx
80101740:	50                   	push   %eax
80101741:	e8 2a 31 00 00       	call   80104870 <memmove>
  log_write(bp);
80101746:	89 34 24             	mov    %esi,(%esp)
80101749:	e8 22 18 00 00       	call   80102f70 <log_write>
  brelse(bp);
8010174e:	89 75 08             	mov    %esi,0x8(%ebp)
80101751:	83 c4 10             	add    $0x10,%esp
}
80101754:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101757:	5b                   	pop    %ebx
80101758:	5e                   	pop    %esi
80101759:	5d                   	pop    %ebp
  brelse(bp);
8010175a:	e9 91 ea ff ff       	jmp    801001f0 <brelse>
8010175f:	90                   	nop

80101760 <idup>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	53                   	push   %ebx
80101764:	83 ec 10             	sub    $0x10,%esp
80101767:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010176a:	68 60 09 11 80       	push   $0x80110960
8010176f:	e8 9c 2f 00 00       	call   80104710 <acquire>
  ip->ref++;
80101774:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101778:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010177f:	e8 2c 2f 00 00       	call   801046b0 <release>
}
80101784:	89 d8                	mov    %ebx,%eax
80101786:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101789:	c9                   	leave  
8010178a:	c3                   	ret    
8010178b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010178f:	90                   	nop

80101790 <ilock>:
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	56                   	push   %esi
80101794:	53                   	push   %ebx
80101795:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101798:	85 db                	test   %ebx,%ebx
8010179a:	0f 84 b7 00 00 00    	je     80101857 <ilock+0xc7>
801017a0:	8b 53 08             	mov    0x8(%ebx),%edx
801017a3:	85 d2                	test   %edx,%edx
801017a5:	0f 8e ac 00 00 00    	jle    80101857 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017ab:	83 ec 0c             	sub    $0xc,%esp
801017ae:	8d 43 0c             	lea    0xc(%ebx),%eax
801017b1:	50                   	push   %eax
801017b2:	e8 99 2c 00 00       	call   80104450 <acquiresleep>
  if(ip->valid == 0){
801017b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ba:	83 c4 10             	add    $0x10,%esp
801017bd:	85 c0                	test   %eax,%eax
801017bf:	74 0f                	je     801017d0 <ilock+0x40>
}
801017c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017c4:	5b                   	pop    %ebx
801017c5:	5e                   	pop    %esi
801017c6:	5d                   	pop    %ebp
801017c7:	c3                   	ret    
801017c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017cf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017d0:	8b 43 04             	mov    0x4(%ebx),%eax
801017d3:	83 ec 08             	sub    $0x8,%esp
801017d6:	c1 e8 03             	shr    $0x3,%eax
801017d9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017df:	50                   	push   %eax
801017e0:	ff 33                	push   (%ebx)
801017e2:	e8 e9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017e7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ea:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017ec:	8b 43 04             	mov    0x4(%ebx),%eax
801017ef:	83 e0 07             	and    $0x7,%eax
801017f2:	c1 e0 06             	shl    $0x6,%eax
801017f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101803:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101807:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010180b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010180f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101813:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101817:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010181b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010181e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101821:	6a 34                	push   $0x34
80101823:	50                   	push   %eax
80101824:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101827:	50                   	push   %eax
80101828:	e8 43 30 00 00       	call   80104870 <memmove>
    brelse(bp);
8010182d:	89 34 24             	mov    %esi,(%esp)
80101830:	e8 bb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101835:	83 c4 10             	add    $0x10,%esp
80101838:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010183d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101844:	0f 85 77 ff ff ff    	jne    801017c1 <ilock+0x31>
      panic("ilock: no type");
8010184a:	83 ec 0c             	sub    $0xc,%esp
8010184d:	68 b0 7b 10 80       	push   $0x80107bb0
80101852:	e8 29 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101857:	83 ec 0c             	sub    $0xc,%esp
8010185a:	68 aa 7b 10 80       	push   $0x80107baa
8010185f:	e8 1c eb ff ff       	call   80100380 <panic>
80101864:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010186b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010186f:	90                   	nop

80101870 <iunlock>:
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	56                   	push   %esi
80101874:	53                   	push   %ebx
80101875:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101878:	85 db                	test   %ebx,%ebx
8010187a:	74 28                	je     801018a4 <iunlock+0x34>
8010187c:	83 ec 0c             	sub    $0xc,%esp
8010187f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101882:	56                   	push   %esi
80101883:	e8 68 2c 00 00       	call   801044f0 <holdingsleep>
80101888:	83 c4 10             	add    $0x10,%esp
8010188b:	85 c0                	test   %eax,%eax
8010188d:	74 15                	je     801018a4 <iunlock+0x34>
8010188f:	8b 43 08             	mov    0x8(%ebx),%eax
80101892:	85 c0                	test   %eax,%eax
80101894:	7e 0e                	jle    801018a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101896:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101899:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010189c:	5b                   	pop    %ebx
8010189d:	5e                   	pop    %esi
8010189e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010189f:	e9 0c 2c 00 00       	jmp    801044b0 <releasesleep>
    panic("iunlock");
801018a4:	83 ec 0c             	sub    $0xc,%esp
801018a7:	68 bf 7b 10 80       	push   $0x80107bbf
801018ac:	e8 cf ea ff ff       	call   80100380 <panic>
801018b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018bf:	90                   	nop

801018c0 <iput>:
{
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	57                   	push   %edi
801018c4:	56                   	push   %esi
801018c5:	53                   	push   %ebx
801018c6:	83 ec 28             	sub    $0x28,%esp
801018c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018cf:	57                   	push   %edi
801018d0:	e8 7b 2b 00 00       	call   80104450 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018d8:	83 c4 10             	add    $0x10,%esp
801018db:	85 d2                	test   %edx,%edx
801018dd:	74 07                	je     801018e6 <iput+0x26>
801018df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018e4:	74 32                	je     80101918 <iput+0x58>
  releasesleep(&ip->lock);
801018e6:	83 ec 0c             	sub    $0xc,%esp
801018e9:	57                   	push   %edi
801018ea:	e8 c1 2b 00 00       	call   801044b0 <releasesleep>
  acquire(&icache.lock);
801018ef:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018f6:	e8 15 2e 00 00       	call   80104710 <acquire>
  ip->ref--;
801018fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ff:	83 c4 10             	add    $0x10,%esp
80101902:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101909:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010190c:	5b                   	pop    %ebx
8010190d:	5e                   	pop    %esi
8010190e:	5f                   	pop    %edi
8010190f:	5d                   	pop    %ebp
  release(&icache.lock);
80101910:	e9 9b 2d 00 00       	jmp    801046b0 <release>
80101915:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101918:	83 ec 0c             	sub    $0xc,%esp
8010191b:	68 60 09 11 80       	push   $0x80110960
80101920:	e8 eb 2d 00 00       	call   80104710 <acquire>
    int r = ip->ref;
80101925:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101928:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010192f:	e8 7c 2d 00 00       	call   801046b0 <release>
    if(r == 1){
80101934:	83 c4 10             	add    $0x10,%esp
80101937:	83 fe 01             	cmp    $0x1,%esi
8010193a:	75 aa                	jne    801018e6 <iput+0x26>
8010193c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101942:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101945:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101948:	89 cf                	mov    %ecx,%edi
8010194a:	eb 0b                	jmp    80101957 <iput+0x97>
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101950:	83 c6 04             	add    $0x4,%esi
80101953:	39 fe                	cmp    %edi,%esi
80101955:	74 19                	je     80101970 <iput+0xb0>
    if(ip->addrs[i]){
80101957:	8b 16                	mov    (%esi),%edx
80101959:	85 d2                	test   %edx,%edx
8010195b:	74 f3                	je     80101950 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010195d:	8b 03                	mov    (%ebx),%eax
8010195f:	e8 6c f8 ff ff       	call   801011d0 <bfree>
      ip->addrs[i] = 0;
80101964:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010196a:	eb e4                	jmp    80101950 <iput+0x90>
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101970:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101976:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101979:	85 c0                	test   %eax,%eax
8010197b:	75 2d                	jne    801019aa <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010197d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101980:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101987:	53                   	push   %ebx
80101988:	e8 53 fd ff ff       	call   801016e0 <iupdate>
      ip->type = 0;
8010198d:	31 c0                	xor    %eax,%eax
8010198f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101993:	89 1c 24             	mov    %ebx,(%esp)
80101996:	e8 45 fd ff ff       	call   801016e0 <iupdate>
      ip->valid = 0;
8010199b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019a2:	83 c4 10             	add    $0x10,%esp
801019a5:	e9 3c ff ff ff       	jmp    801018e6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019aa:	83 ec 08             	sub    $0x8,%esp
801019ad:	50                   	push   %eax
801019ae:	ff 33                	push   (%ebx)
801019b0:	e8 1b e7 ff ff       	call   801000d0 <bread>
801019b5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019b8:	83 c4 10             	add    $0x10,%esp
801019bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019c4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019c7:	89 cf                	mov    %ecx,%edi
801019c9:	eb 0c                	jmp    801019d7 <iput+0x117>
801019cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019cf:	90                   	nop
801019d0:	83 c6 04             	add    $0x4,%esi
801019d3:	39 f7                	cmp    %esi,%edi
801019d5:	74 0f                	je     801019e6 <iput+0x126>
      if(a[j])
801019d7:	8b 16                	mov    (%esi),%edx
801019d9:	85 d2                	test   %edx,%edx
801019db:	74 f3                	je     801019d0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019dd:	8b 03                	mov    (%ebx),%eax
801019df:	e8 ec f7 ff ff       	call   801011d0 <bfree>
801019e4:	eb ea                	jmp    801019d0 <iput+0x110>
    brelse(bp);
801019e6:	83 ec 0c             	sub    $0xc,%esp
801019e9:	ff 75 e4             	push   -0x1c(%ebp)
801019ec:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019ef:	e8 fc e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019f4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019fa:	8b 03                	mov    (%ebx),%eax
801019fc:	e8 cf f7 ff ff       	call   801011d0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a01:	83 c4 10             	add    $0x10,%esp
80101a04:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a0b:	00 00 00 
80101a0e:	e9 6a ff ff ff       	jmp    8010197d <iput+0xbd>
80101a13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a20 <iunlockput>:
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	56                   	push   %esi
80101a24:	53                   	push   %ebx
80101a25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a28:	85 db                	test   %ebx,%ebx
80101a2a:	74 34                	je     80101a60 <iunlockput+0x40>
80101a2c:	83 ec 0c             	sub    $0xc,%esp
80101a2f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a32:	56                   	push   %esi
80101a33:	e8 b8 2a 00 00       	call   801044f0 <holdingsleep>
80101a38:	83 c4 10             	add    $0x10,%esp
80101a3b:	85 c0                	test   %eax,%eax
80101a3d:	74 21                	je     80101a60 <iunlockput+0x40>
80101a3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a42:	85 c0                	test   %eax,%eax
80101a44:	7e 1a                	jle    80101a60 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a46:	83 ec 0c             	sub    $0xc,%esp
80101a49:	56                   	push   %esi
80101a4a:	e8 61 2a 00 00       	call   801044b0 <releasesleep>
  iput(ip);
80101a4f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a52:	83 c4 10             	add    $0x10,%esp
}
80101a55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a58:	5b                   	pop    %ebx
80101a59:	5e                   	pop    %esi
80101a5a:	5d                   	pop    %ebp
  iput(ip);
80101a5b:	e9 60 fe ff ff       	jmp    801018c0 <iput>
    panic("iunlock");
80101a60:	83 ec 0c             	sub    $0xc,%esp
80101a63:	68 bf 7b 10 80       	push   $0x80107bbf
80101a68:	e8 13 e9 ff ff       	call   80100380 <panic>
80101a6d:	8d 76 00             	lea    0x0(%esi),%esi

80101a70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	8b 55 08             	mov    0x8(%ebp),%edx
80101a76:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a79:	8b 0a                	mov    (%edx),%ecx
80101a7b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a7e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a81:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a84:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a88:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a8b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a8f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a93:	8b 52 58             	mov    0x58(%edx),%edx
80101a96:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a99:	5d                   	pop    %ebp
80101a9a:	c3                   	ret    
80101a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a9f:	90                   	nop

80101aa0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	57                   	push   %edi
80101aa4:	56                   	push   %esi
80101aa5:	53                   	push   %ebx
80101aa6:	83 ec 1c             	sub    $0x1c,%esp
80101aa9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101aac:	8b 45 08             	mov    0x8(%ebp),%eax
80101aaf:	8b 75 10             	mov    0x10(%ebp),%esi
80101ab2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ab5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ab8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101abd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ac0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ac3:	0f 84 a7 00 00 00    	je     80101b70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ac9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101acc:	8b 40 58             	mov    0x58(%eax),%eax
80101acf:	39 c6                	cmp    %eax,%esi
80101ad1:	0f 87 ba 00 00 00    	ja     80101b91 <readi+0xf1>
80101ad7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101ada:	31 c9                	xor    %ecx,%ecx
80101adc:	89 da                	mov    %ebx,%edx
80101ade:	01 f2                	add    %esi,%edx
80101ae0:	0f 92 c1             	setb   %cl
80101ae3:	89 cf                	mov    %ecx,%edi
80101ae5:	0f 82 a6 00 00 00    	jb     80101b91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aeb:	89 c1                	mov    %eax,%ecx
80101aed:	29 f1                	sub    %esi,%ecx
80101aef:	39 d0                	cmp    %edx,%eax
80101af1:	0f 43 cb             	cmovae %ebx,%ecx
80101af4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101af7:	85 c9                	test   %ecx,%ecx
80101af9:	74 67                	je     80101b62 <readi+0xc2>
80101afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b03:	89 f2                	mov    %esi,%edx
80101b05:	c1 ea 09             	shr    $0x9,%edx
80101b08:	89 d8                	mov    %ebx,%eax
80101b0a:	e8 51 f9 ff ff       	call   80101460 <bmap>
80101b0f:	83 ec 08             	sub    $0x8,%esp
80101b12:	50                   	push   %eax
80101b13:	ff 33                	push   (%ebx)
80101b15:	e8 b6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b1d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b22:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b24:	89 f0                	mov    %esi,%eax
80101b26:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b2b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b30:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b32:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b36:	39 d9                	cmp    %ebx,%ecx
80101b38:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3b:	83 c4 0c             	add    $0xc,%esp
80101b3e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b3f:	01 df                	add    %ebx,%edi
80101b41:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b43:	50                   	push   %eax
80101b44:	ff 75 e0             	push   -0x20(%ebp)
80101b47:	e8 24 2d 00 00       	call   80104870 <memmove>
    brelse(bp);
80101b4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b4f:	89 14 24             	mov    %edx,(%esp)
80101b52:	e8 99 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b5a:	83 c4 10             	add    $0x10,%esp
80101b5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b60:	77 9e                	ja     80101b00 <readi+0x60>
  }
  return n;
80101b62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b68:	5b                   	pop    %ebx
80101b69:	5e                   	pop    %esi
80101b6a:	5f                   	pop    %edi
80101b6b:	5d                   	pop    %ebp
80101b6c:	c3                   	ret    
80101b6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b74:	66 83 f8 09          	cmp    $0x9,%ax
80101b78:	77 17                	ja     80101b91 <readi+0xf1>
80101b7a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101b81:	85 c0                	test   %eax,%eax
80101b83:	74 0c                	je     80101b91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b8b:	5b                   	pop    %ebx
80101b8c:	5e                   	pop    %esi
80101b8d:	5f                   	pop    %edi
80101b8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b8f:	ff e0                	jmp    *%eax
      return -1;
80101b91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b96:	eb cd                	jmp    80101b65 <readi+0xc5>
80101b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b9f:	90                   	nop

80101ba0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101baf:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bb2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bb7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101bba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bbd:	8b 75 10             	mov    0x10(%ebp),%esi
80101bc0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bc3:	0f 84 b7 00 00 00    	je     80101c80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bcc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bcf:	0f 87 e7 00 00 00    	ja     80101cbc <writei+0x11c>
80101bd5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bd8:	31 d2                	xor    %edx,%edx
80101bda:	89 f8                	mov    %edi,%eax
80101bdc:	01 f0                	add    %esi,%eax
80101bde:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101be1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101be6:	0f 87 d0 00 00 00    	ja     80101cbc <writei+0x11c>
80101bec:	85 d2                	test   %edx,%edx
80101bee:	0f 85 c8 00 00 00    	jne    80101cbc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bf4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bfb:	85 ff                	test   %edi,%edi
80101bfd:	74 72                	je     80101c71 <writei+0xd1>
80101bff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c03:	89 f2                	mov    %esi,%edx
80101c05:	c1 ea 09             	shr    $0x9,%edx
80101c08:	89 f8                	mov    %edi,%eax
80101c0a:	e8 51 f8 ff ff       	call   80101460 <bmap>
80101c0f:	83 ec 08             	sub    $0x8,%esp
80101c12:	50                   	push   %eax
80101c13:	ff 37                	push   (%edi)
80101c15:	e8 b6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c1a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c1f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c22:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c25:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c27:	89 f0                	mov    %esi,%eax
80101c29:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c2e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c30:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c34:	39 d9                	cmp    %ebx,%ecx
80101c36:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c39:	83 c4 0c             	add    $0xc,%esp
80101c3c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c3d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c3f:	ff 75 dc             	push   -0x24(%ebp)
80101c42:	50                   	push   %eax
80101c43:	e8 28 2c 00 00       	call   80104870 <memmove>
    log_write(bp);
80101c48:	89 3c 24             	mov    %edi,(%esp)
80101c4b:	e8 20 13 00 00       	call   80102f70 <log_write>
    brelse(bp);
80101c50:	89 3c 24             	mov    %edi,(%esp)
80101c53:	e8 98 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c58:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c5b:	83 c4 10             	add    $0x10,%esp
80101c5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c61:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c64:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c67:	77 97                	ja     80101c00 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c6f:	77 37                	ja     80101ca8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c71:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c77:	5b                   	pop    %ebx
80101c78:	5e                   	pop    %esi
80101c79:	5f                   	pop    %edi
80101c7a:	5d                   	pop    %ebp
80101c7b:	c3                   	ret    
80101c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c84:	66 83 f8 09          	cmp    $0x9,%ax
80101c88:	77 32                	ja     80101cbc <writei+0x11c>
80101c8a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101c91:	85 c0                	test   %eax,%eax
80101c93:	74 27                	je     80101cbc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c95:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c9b:	5b                   	pop    %ebx
80101c9c:	5e                   	pop    %esi
80101c9d:	5f                   	pop    %edi
80101c9e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c9f:	ff e0                	jmp    *%eax
80101ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101ca8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101cab:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101cb1:	50                   	push   %eax
80101cb2:	e8 29 fa ff ff       	call   801016e0 <iupdate>
80101cb7:	83 c4 10             	add    $0x10,%esp
80101cba:	eb b5                	jmp    80101c71 <writei+0xd1>
      return -1;
80101cbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cc1:	eb b1                	jmp    80101c74 <writei+0xd4>
80101cc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cd6:	6a 0e                	push   $0xe
80101cd8:	ff 75 0c             	push   0xc(%ebp)
80101cdb:	ff 75 08             	push   0x8(%ebp)
80101cde:	e8 fd 2b 00 00       	call   801048e0 <strncmp>
}
80101ce3:	c9                   	leave  
80101ce4:	c3                   	ret    
80101ce5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101cf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	56                   	push   %esi
80101cf5:	53                   	push   %ebx
80101cf6:	83 ec 1c             	sub    $0x1c,%esp
80101cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d01:	0f 85 85 00 00 00    	jne    80101d8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d07:	8b 53 58             	mov    0x58(%ebx),%edx
80101d0a:	31 ff                	xor    %edi,%edi
80101d0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d0f:	85 d2                	test   %edx,%edx
80101d11:	74 3e                	je     80101d51 <dirlookup+0x61>
80101d13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d17:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d18:	6a 10                	push   $0x10
80101d1a:	57                   	push   %edi
80101d1b:	56                   	push   %esi
80101d1c:	53                   	push   %ebx
80101d1d:	e8 7e fd ff ff       	call   80101aa0 <readi>
80101d22:	83 c4 10             	add    $0x10,%esp
80101d25:	83 f8 10             	cmp    $0x10,%eax
80101d28:	75 55                	jne    80101d7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d2f:	74 18                	je     80101d49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d31:	83 ec 04             	sub    $0x4,%esp
80101d34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d37:	6a 0e                	push   $0xe
80101d39:	50                   	push   %eax
80101d3a:	ff 75 0c             	push   0xc(%ebp)
80101d3d:	e8 9e 2b 00 00       	call   801048e0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d42:	83 c4 10             	add    $0x10,%esp
80101d45:	85 c0                	test   %eax,%eax
80101d47:	74 17                	je     80101d60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d49:	83 c7 10             	add    $0x10,%edi
80101d4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d4f:	72 c7                	jb     80101d18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d54:	31 c0                	xor    %eax,%eax
}
80101d56:	5b                   	pop    %ebx
80101d57:	5e                   	pop    %esi
80101d58:	5f                   	pop    %edi
80101d59:	5d                   	pop    %ebp
80101d5a:	c3                   	ret    
80101d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d5f:	90                   	nop
      if(poff)
80101d60:	8b 45 10             	mov    0x10(%ebp),%eax
80101d63:	85 c0                	test   %eax,%eax
80101d65:	74 05                	je     80101d6c <dirlookup+0x7c>
        *poff = off;
80101d67:	8b 45 10             	mov    0x10(%ebp),%eax
80101d6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d70:	8b 03                	mov    (%ebx),%eax
80101d72:	e8 e9 f5 ff ff       	call   80101360 <iget>
}
80101d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d7a:	5b                   	pop    %ebx
80101d7b:	5e                   	pop    %esi
80101d7c:	5f                   	pop    %edi
80101d7d:	5d                   	pop    %ebp
80101d7e:	c3                   	ret    
      panic("dirlookup read");
80101d7f:	83 ec 0c             	sub    $0xc,%esp
80101d82:	68 d9 7b 10 80       	push   $0x80107bd9
80101d87:	e8 f4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d8c:	83 ec 0c             	sub    $0xc,%esp
80101d8f:	68 c7 7b 10 80       	push   $0x80107bc7
80101d94:	e8 e7 e5 ff ff       	call   80100380 <panic>
80101d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101da0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	57                   	push   %edi
80101da4:	56                   	push   %esi
80101da5:	53                   	push   %ebx
80101da6:	89 c3                	mov    %eax,%ebx
80101da8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dae:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101db4:	0f 84 64 01 00 00    	je     80101f1e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dba:	e8 01 1c 00 00       	call   801039c0 <myproc>
  acquire(&icache.lock);
80101dbf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dc2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dc5:	68 60 09 11 80       	push   $0x80110960
80101dca:	e8 41 29 00 00       	call   80104710 <acquire>
  ip->ref++;
80101dcf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dda:	e8 d1 28 00 00       	call   801046b0 <release>
80101ddf:	83 c4 10             	add    $0x10,%esp
80101de2:	eb 07                	jmp    80101deb <namex+0x4b>
80101de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101de8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101deb:	0f b6 03             	movzbl (%ebx),%eax
80101dee:	3c 2f                	cmp    $0x2f,%al
80101df0:	74 f6                	je     80101de8 <namex+0x48>
  if(*path == 0)
80101df2:	84 c0                	test   %al,%al
80101df4:	0f 84 06 01 00 00    	je     80101f00 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dfa:	0f b6 03             	movzbl (%ebx),%eax
80101dfd:	84 c0                	test   %al,%al
80101dff:	0f 84 10 01 00 00    	je     80101f15 <namex+0x175>
80101e05:	89 df                	mov    %ebx,%edi
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	0f 84 06 01 00 00    	je     80101f15 <namex+0x175>
80101e0f:	90                   	nop
80101e10:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e14:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	74 04                	je     80101e1f <namex+0x7f>
80101e1b:	84 c0                	test   %al,%al
80101e1d:	75 f1                	jne    80101e10 <namex+0x70>
  len = path - s;
80101e1f:	89 f8                	mov    %edi,%eax
80101e21:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e23:	83 f8 0d             	cmp    $0xd,%eax
80101e26:	0f 8e ac 00 00 00    	jle    80101ed8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e2c:	83 ec 04             	sub    $0x4,%esp
80101e2f:	6a 0e                	push   $0xe
80101e31:	53                   	push   %ebx
    path++;
80101e32:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e34:	ff 75 e4             	push   -0x1c(%ebp)
80101e37:	e8 34 2a 00 00       	call   80104870 <memmove>
80101e3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e3f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e42:	75 0c                	jne    80101e50 <namex+0xb0>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e4b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e4e:	74 f8                	je     80101e48 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e50:	83 ec 0c             	sub    $0xc,%esp
80101e53:	56                   	push   %esi
80101e54:	e8 37 f9 ff ff       	call   80101790 <ilock>
    if(ip->type != T_DIR){
80101e59:	83 c4 10             	add    $0x10,%esp
80101e5c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e61:	0f 85 cd 00 00 00    	jne    80101f34 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 09                	je     80101e77 <namex+0xd7>
80101e6e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e71:	0f 84 22 01 00 00    	je     80101f99 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e77:	83 ec 04             	sub    $0x4,%esp
80101e7a:	6a 00                	push   $0x0
80101e7c:	ff 75 e4             	push   -0x1c(%ebp)
80101e7f:	56                   	push   %esi
80101e80:	e8 6b fe ff ff       	call   80101cf0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e88:	83 c4 10             	add    $0x10,%esp
80101e8b:	89 c7                	mov    %eax,%edi
80101e8d:	85 c0                	test   %eax,%eax
80101e8f:	0f 84 e1 00 00 00    	je     80101f76 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e95:	83 ec 0c             	sub    $0xc,%esp
80101e98:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e9b:	52                   	push   %edx
80101e9c:	e8 4f 26 00 00       	call   801044f0 <holdingsleep>
80101ea1:	83 c4 10             	add    $0x10,%esp
80101ea4:	85 c0                	test   %eax,%eax
80101ea6:	0f 84 30 01 00 00    	je     80101fdc <namex+0x23c>
80101eac:	8b 56 08             	mov    0x8(%esi),%edx
80101eaf:	85 d2                	test   %edx,%edx
80101eb1:	0f 8e 25 01 00 00    	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101eb7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eba:	83 ec 0c             	sub    $0xc,%esp
80101ebd:	52                   	push   %edx
80101ebe:	e8 ed 25 00 00       	call   801044b0 <releasesleep>
  iput(ip);
80101ec3:	89 34 24             	mov    %esi,(%esp)
80101ec6:	89 fe                	mov    %edi,%esi
80101ec8:	e8 f3 f9 ff ff       	call   801018c0 <iput>
80101ecd:	83 c4 10             	add    $0x10,%esp
80101ed0:	e9 16 ff ff ff       	jmp    80101deb <namex+0x4b>
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ed8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101edb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ede:	83 ec 04             	sub    $0x4,%esp
80101ee1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ee4:	50                   	push   %eax
80101ee5:	53                   	push   %ebx
    name[len] = 0;
80101ee6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ee8:	ff 75 e4             	push   -0x1c(%ebp)
80101eeb:	e8 80 29 00 00       	call   80104870 <memmove>
    name[len] = 0;
80101ef0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ef3:	83 c4 10             	add    $0x10,%esp
80101ef6:	c6 02 00             	movb   $0x0,(%edx)
80101ef9:	e9 41 ff ff ff       	jmp    80101e3f <namex+0x9f>
80101efe:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f00:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f03:	85 c0                	test   %eax,%eax
80101f05:	0f 85 be 00 00 00    	jne    80101fc9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0e:	89 f0                	mov    %esi,%eax
80101f10:	5b                   	pop    %ebx
80101f11:	5e                   	pop    %esi
80101f12:	5f                   	pop    %edi
80101f13:	5d                   	pop    %ebp
80101f14:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f15:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f18:	89 df                	mov    %ebx,%edi
80101f1a:	31 c0                	xor    %eax,%eax
80101f1c:	eb c0                	jmp    80101ede <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f1e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f23:	b8 01 00 00 00       	mov    $0x1,%eax
80101f28:	e8 33 f4 ff ff       	call   80101360 <iget>
80101f2d:	89 c6                	mov    %eax,%esi
80101f2f:	e9 b7 fe ff ff       	jmp    80101deb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f34:	83 ec 0c             	sub    $0xc,%esp
80101f37:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f3a:	53                   	push   %ebx
80101f3b:	e8 b0 25 00 00       	call   801044f0 <holdingsleep>
80101f40:	83 c4 10             	add    $0x10,%esp
80101f43:	85 c0                	test   %eax,%eax
80101f45:	0f 84 91 00 00 00    	je     80101fdc <namex+0x23c>
80101f4b:	8b 46 08             	mov    0x8(%esi),%eax
80101f4e:	85 c0                	test   %eax,%eax
80101f50:	0f 8e 86 00 00 00    	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101f56:	83 ec 0c             	sub    $0xc,%esp
80101f59:	53                   	push   %ebx
80101f5a:	e8 51 25 00 00       	call   801044b0 <releasesleep>
  iput(ip);
80101f5f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f62:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f64:	e8 57 f9 ff ff       	call   801018c0 <iput>
      return 0;
80101f69:	83 c4 10             	add    $0x10,%esp
}
80101f6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f6f:	89 f0                	mov    %esi,%eax
80101f71:	5b                   	pop    %ebx
80101f72:	5e                   	pop    %esi
80101f73:	5f                   	pop    %edi
80101f74:	5d                   	pop    %ebp
80101f75:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f76:	83 ec 0c             	sub    $0xc,%esp
80101f79:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f7c:	52                   	push   %edx
80101f7d:	e8 6e 25 00 00       	call   801044f0 <holdingsleep>
80101f82:	83 c4 10             	add    $0x10,%esp
80101f85:	85 c0                	test   %eax,%eax
80101f87:	74 53                	je     80101fdc <namex+0x23c>
80101f89:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f8c:	85 c9                	test   %ecx,%ecx
80101f8e:	7e 4c                	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101f90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f93:	83 ec 0c             	sub    $0xc,%esp
80101f96:	52                   	push   %edx
80101f97:	eb c1                	jmp    80101f5a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f99:	83 ec 0c             	sub    $0xc,%esp
80101f9c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f9f:	53                   	push   %ebx
80101fa0:	e8 4b 25 00 00       	call   801044f0 <holdingsleep>
80101fa5:	83 c4 10             	add    $0x10,%esp
80101fa8:	85 c0                	test   %eax,%eax
80101faa:	74 30                	je     80101fdc <namex+0x23c>
80101fac:	8b 7e 08             	mov    0x8(%esi),%edi
80101faf:	85 ff                	test   %edi,%edi
80101fb1:	7e 29                	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101fb3:	83 ec 0c             	sub    $0xc,%esp
80101fb6:	53                   	push   %ebx
80101fb7:	e8 f4 24 00 00       	call   801044b0 <releasesleep>
}
80101fbc:	83 c4 10             	add    $0x10,%esp
}
80101fbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fc2:	89 f0                	mov    %esi,%eax
80101fc4:	5b                   	pop    %ebx
80101fc5:	5e                   	pop    %esi
80101fc6:	5f                   	pop    %edi
80101fc7:	5d                   	pop    %ebp
80101fc8:	c3                   	ret    
    iput(ip);
80101fc9:	83 ec 0c             	sub    $0xc,%esp
80101fcc:	56                   	push   %esi
    return 0;
80101fcd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fcf:	e8 ec f8 ff ff       	call   801018c0 <iput>
    return 0;
80101fd4:	83 c4 10             	add    $0x10,%esp
80101fd7:	e9 2f ff ff ff       	jmp    80101f0b <namex+0x16b>
    panic("iunlock");
80101fdc:	83 ec 0c             	sub    $0xc,%esp
80101fdf:	68 bf 7b 10 80       	push   $0x80107bbf
80101fe4:	e8 97 e3 ff ff       	call   80100380 <panic>
80101fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ff0 <dirlink>:
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	57                   	push   %edi
80101ff4:	56                   	push   %esi
80101ff5:	53                   	push   %ebx
80101ff6:	83 ec 20             	sub    $0x20,%esp
80101ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101ffc:	6a 00                	push   $0x0
80101ffe:	ff 75 0c             	push   0xc(%ebp)
80102001:	53                   	push   %ebx
80102002:	e8 e9 fc ff ff       	call   80101cf0 <dirlookup>
80102007:	83 c4 10             	add    $0x10,%esp
8010200a:	85 c0                	test   %eax,%eax
8010200c:	75 67                	jne    80102075 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010200e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102011:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102014:	85 ff                	test   %edi,%edi
80102016:	74 29                	je     80102041 <dirlink+0x51>
80102018:	31 ff                	xor    %edi,%edi
8010201a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010201d:	eb 09                	jmp    80102028 <dirlink+0x38>
8010201f:	90                   	nop
80102020:	83 c7 10             	add    $0x10,%edi
80102023:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102026:	73 19                	jae    80102041 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102028:	6a 10                	push   $0x10
8010202a:	57                   	push   %edi
8010202b:	56                   	push   %esi
8010202c:	53                   	push   %ebx
8010202d:	e8 6e fa ff ff       	call   80101aa0 <readi>
80102032:	83 c4 10             	add    $0x10,%esp
80102035:	83 f8 10             	cmp    $0x10,%eax
80102038:	75 4e                	jne    80102088 <dirlink+0x98>
    if(de.inum == 0)
8010203a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010203f:	75 df                	jne    80102020 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102041:	83 ec 04             	sub    $0x4,%esp
80102044:	8d 45 da             	lea    -0x26(%ebp),%eax
80102047:	6a 0e                	push   $0xe
80102049:	ff 75 0c             	push   0xc(%ebp)
8010204c:	50                   	push   %eax
8010204d:	e8 de 28 00 00       	call   80104930 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102052:	6a 10                	push   $0x10
  de.inum = inum;
80102054:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102057:	57                   	push   %edi
80102058:	56                   	push   %esi
80102059:	53                   	push   %ebx
  de.inum = inum;
8010205a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010205e:	e8 3d fb ff ff       	call   80101ba0 <writei>
80102063:	83 c4 20             	add    $0x20,%esp
80102066:	83 f8 10             	cmp    $0x10,%eax
80102069:	75 2a                	jne    80102095 <dirlink+0xa5>
  return 0;
8010206b:	31 c0                	xor    %eax,%eax
}
8010206d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102070:	5b                   	pop    %ebx
80102071:	5e                   	pop    %esi
80102072:	5f                   	pop    %edi
80102073:	5d                   	pop    %ebp
80102074:	c3                   	ret    
    iput(ip);
80102075:	83 ec 0c             	sub    $0xc,%esp
80102078:	50                   	push   %eax
80102079:	e8 42 f8 ff ff       	call   801018c0 <iput>
    return -1;
8010207e:	83 c4 10             	add    $0x10,%esp
80102081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102086:	eb e5                	jmp    8010206d <dirlink+0x7d>
      panic("dirlink read");
80102088:	83 ec 0c             	sub    $0xc,%esp
8010208b:	68 e8 7b 10 80       	push   $0x80107be8
80102090:	e8 eb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102095:	83 ec 0c             	sub    $0xc,%esp
80102098:	68 ce 81 10 80       	push   $0x801081ce
8010209d:	e8 de e2 ff ff       	call   80100380 <panic>
801020a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020b0 <namei>:

struct inode*
namei(char *path)
{
801020b0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020b1:	31 d2                	xor    %edx,%edx
{
801020b3:	89 e5                	mov    %esp,%ebp
801020b5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020b8:	8b 45 08             	mov    0x8(%ebp),%eax
801020bb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020be:	e8 dd fc ff ff       	call   80101da0 <namex>
}
801020c3:	c9                   	leave  
801020c4:	c3                   	ret    
801020c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020d0:	55                   	push   %ebp
  return namex(path, 1, name);
801020d1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020d6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020db:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020de:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020df:	e9 bc fc ff ff       	jmp    80101da0 <namex>
801020e4:	66 90                	xchg   %ax,%ax
801020e6:	66 90                	xchg   %ax,%ax
801020e8:	66 90                	xchg   %ax,%ax
801020ea:	66 90                	xchg   %ax,%ax
801020ec:	66 90                	xchg   %ax,%ax
801020ee:	66 90                	xchg   %ax,%ax

801020f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	57                   	push   %edi
801020f4:	56                   	push   %esi
801020f5:	53                   	push   %ebx
801020f6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020f9:	85 c0                	test   %eax,%eax
801020fb:	0f 84 b4 00 00 00    	je     801021b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102101:	8b 70 08             	mov    0x8(%eax),%esi
80102104:	89 c3                	mov    %eax,%ebx
80102106:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010210c:	0f 87 96 00 00 00    	ja     801021a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102112:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010211e:	66 90                	xchg   %ax,%ax
80102120:	89 ca                	mov    %ecx,%edx
80102122:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102123:	83 e0 c0             	and    $0xffffffc0,%eax
80102126:	3c 40                	cmp    $0x40,%al
80102128:	75 f6                	jne    80102120 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010212a:	31 ff                	xor    %edi,%edi
8010212c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102131:	89 f8                	mov    %edi,%eax
80102133:	ee                   	out    %al,(%dx)
80102134:	b8 01 00 00 00       	mov    $0x1,%eax
80102139:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010213e:	ee                   	out    %al,(%dx)
8010213f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102144:	89 f0                	mov    %esi,%eax
80102146:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102147:	89 f0                	mov    %esi,%eax
80102149:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010214e:	c1 f8 08             	sar    $0x8,%eax
80102151:	ee                   	out    %al,(%dx)
80102152:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102157:	89 f8                	mov    %edi,%eax
80102159:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010215a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010215e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102163:	c1 e0 04             	shl    $0x4,%eax
80102166:	83 e0 10             	and    $0x10,%eax
80102169:	83 c8 e0             	or     $0xffffffe0,%eax
8010216c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010216d:	f6 03 04             	testb  $0x4,(%ebx)
80102170:	75 16                	jne    80102188 <idestart+0x98>
80102172:	b8 20 00 00 00       	mov    $0x20,%eax
80102177:	89 ca                	mov    %ecx,%edx
80102179:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010217a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010217d:	5b                   	pop    %ebx
8010217e:	5e                   	pop    %esi
8010217f:	5f                   	pop    %edi
80102180:	5d                   	pop    %ebp
80102181:	c3                   	ret    
80102182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102188:	b8 30 00 00 00       	mov    $0x30,%eax
8010218d:	89 ca                	mov    %ecx,%edx
8010218f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102190:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102195:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102198:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010219d:	fc                   	cld    
8010219e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021a3:	5b                   	pop    %ebx
801021a4:	5e                   	pop    %esi
801021a5:	5f                   	pop    %edi
801021a6:	5d                   	pop    %ebp
801021a7:	c3                   	ret    
    panic("incorrect blockno");
801021a8:	83 ec 0c             	sub    $0xc,%esp
801021ab:	68 54 7c 10 80       	push   $0x80107c54
801021b0:	e8 cb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	68 4b 7c 10 80       	push   $0x80107c4b
801021bd:	e8 be e1 ff ff       	call   80100380 <panic>
801021c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021d0 <ideinit>:
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021d6:	68 66 7c 10 80       	push   $0x80107c66
801021db:	68 00 26 11 80       	push   $0x80112600
801021e0:	e8 5b 23 00 00       	call   80104540 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021e5:	58                   	pop    %eax
801021e6:	a1 84 27 19 80       	mov    0x80192784,%eax
801021eb:	5a                   	pop    %edx
801021ec:	83 e8 01             	sub    $0x1,%eax
801021ef:	50                   	push   %eax
801021f0:	6a 0e                	push   $0xe
801021f2:	e8 99 02 00 00       	call   80102490 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ff:	90                   	nop
80102200:	ec                   	in     (%dx),%al
80102201:	83 e0 c0             	and    $0xffffffc0,%eax
80102204:	3c 40                	cmp    $0x40,%al
80102206:	75 f8                	jne    80102200 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102208:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010220d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102212:	ee                   	out    %al,(%dx)
80102213:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102218:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010221d:	eb 06                	jmp    80102225 <ideinit+0x55>
8010221f:	90                   	nop
  for(i=0; i<1000; i++){
80102220:	83 e9 01             	sub    $0x1,%ecx
80102223:	74 0f                	je     80102234 <ideinit+0x64>
80102225:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102226:	84 c0                	test   %al,%al
80102228:	74 f6                	je     80102220 <ideinit+0x50>
      havedisk1 = 1;
8010222a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102231:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102234:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102239:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010223e:	ee                   	out    %al,(%dx)
}
8010223f:	c9                   	leave  
80102240:	c3                   	ret    
80102241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010224f:	90                   	nop

80102250 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102250:	55                   	push   %ebp
80102251:	89 e5                	mov    %esp,%ebp
80102253:	57                   	push   %edi
80102254:	56                   	push   %esi
80102255:	53                   	push   %ebx
80102256:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102259:	68 00 26 11 80       	push   $0x80112600
8010225e:	e8 ad 24 00 00       	call   80104710 <acquire>

  if((b = idequeue) == 0){
80102263:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102269:	83 c4 10             	add    $0x10,%esp
8010226c:	85 db                	test   %ebx,%ebx
8010226e:	74 63                	je     801022d3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102270:	8b 43 58             	mov    0x58(%ebx),%eax
80102273:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102278:	8b 33                	mov    (%ebx),%esi
8010227a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102280:	75 2f                	jne    801022b1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102282:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228e:	66 90                	xchg   %ax,%ax
80102290:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102291:	89 c1                	mov    %eax,%ecx
80102293:	83 e1 c0             	and    $0xffffffc0,%ecx
80102296:	80 f9 40             	cmp    $0x40,%cl
80102299:	75 f5                	jne    80102290 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010229b:	a8 21                	test   $0x21,%al
8010229d:	75 12                	jne    801022b1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010229f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022a2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022a7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022ac:	fc                   	cld    
801022ad:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022af:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022b1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022b4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022b7:	83 ce 02             	or     $0x2,%esi
801022ba:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022bc:	53                   	push   %ebx
801022bd:	e8 ae 1f 00 00       	call   80104270 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022c2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022c7:	83 c4 10             	add    $0x10,%esp
801022ca:	85 c0                	test   %eax,%eax
801022cc:	74 05                	je     801022d3 <ideintr+0x83>
    idestart(idequeue);
801022ce:	e8 1d fe ff ff       	call   801020f0 <idestart>
    release(&idelock);
801022d3:	83 ec 0c             	sub    $0xc,%esp
801022d6:	68 00 26 11 80       	push   $0x80112600
801022db:	e8 d0 23 00 00       	call   801046b0 <release>

  release(&idelock);
}
801022e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022e3:	5b                   	pop    %ebx
801022e4:	5e                   	pop    %esi
801022e5:	5f                   	pop    %edi
801022e6:	5d                   	pop    %ebp
801022e7:	c3                   	ret    
801022e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ef:	90                   	nop

801022f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	53                   	push   %ebx
801022f4:	83 ec 10             	sub    $0x10,%esp
801022f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801022fd:	50                   	push   %eax
801022fe:	e8 ed 21 00 00       	call   801044f0 <holdingsleep>
80102303:	83 c4 10             	add    $0x10,%esp
80102306:	85 c0                	test   %eax,%eax
80102308:	0f 84 c3 00 00 00    	je     801023d1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010230e:	8b 03                	mov    (%ebx),%eax
80102310:	83 e0 06             	and    $0x6,%eax
80102313:	83 f8 02             	cmp    $0x2,%eax
80102316:	0f 84 a8 00 00 00    	je     801023c4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010231c:	8b 53 04             	mov    0x4(%ebx),%edx
8010231f:	85 d2                	test   %edx,%edx
80102321:	74 0d                	je     80102330 <iderw+0x40>
80102323:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102328:	85 c0                	test   %eax,%eax
8010232a:	0f 84 87 00 00 00    	je     801023b7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102330:	83 ec 0c             	sub    $0xc,%esp
80102333:	68 00 26 11 80       	push   $0x80112600
80102338:	e8 d3 23 00 00       	call   80104710 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010233d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102342:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102349:	83 c4 10             	add    $0x10,%esp
8010234c:	85 c0                	test   %eax,%eax
8010234e:	74 60                	je     801023b0 <iderw+0xc0>
80102350:	89 c2                	mov    %eax,%edx
80102352:	8b 40 58             	mov    0x58(%eax),%eax
80102355:	85 c0                	test   %eax,%eax
80102357:	75 f7                	jne    80102350 <iderw+0x60>
80102359:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010235c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010235e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102364:	74 3a                	je     801023a0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102366:	8b 03                	mov    (%ebx),%eax
80102368:	83 e0 06             	and    $0x6,%eax
8010236b:	83 f8 02             	cmp    $0x2,%eax
8010236e:	74 1b                	je     8010238b <iderw+0x9b>
    sleep(b, &idelock);
80102370:	83 ec 08             	sub    $0x8,%esp
80102373:	68 00 26 11 80       	push   $0x80112600
80102378:	53                   	push   %ebx
80102379:	e8 32 1e 00 00       	call   801041b0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010237e:	8b 03                	mov    (%ebx),%eax
80102380:	83 c4 10             	add    $0x10,%esp
80102383:	83 e0 06             	and    $0x6,%eax
80102386:	83 f8 02             	cmp    $0x2,%eax
80102389:	75 e5                	jne    80102370 <iderw+0x80>
  }


  release(&idelock);
8010238b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102392:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102395:	c9                   	leave  
  release(&idelock);
80102396:	e9 15 23 00 00       	jmp    801046b0 <release>
8010239b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010239f:	90                   	nop
    idestart(b);
801023a0:	89 d8                	mov    %ebx,%eax
801023a2:	e8 49 fd ff ff       	call   801020f0 <idestart>
801023a7:	eb bd                	jmp    80102366 <iderw+0x76>
801023a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023b0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801023b5:	eb a5                	jmp    8010235c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023b7:	83 ec 0c             	sub    $0xc,%esp
801023ba:	68 95 7c 10 80       	push   $0x80107c95
801023bf:	e8 bc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023c4:	83 ec 0c             	sub    $0xc,%esp
801023c7:	68 80 7c 10 80       	push   $0x80107c80
801023cc:	e8 af df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023d1:	83 ec 0c             	sub    $0xc,%esp
801023d4:	68 6a 7c 10 80       	push   $0x80107c6a
801023d9:	e8 a2 df ff ff       	call   80100380 <panic>
801023de:	66 90                	xchg   %ax,%ax

801023e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023e0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023e1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023e8:	00 c0 fe 
{
801023eb:	89 e5                	mov    %esp,%ebp
801023ed:	56                   	push   %esi
801023ee:	53                   	push   %ebx
  ioapic->reg = reg;
801023ef:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023f6:	00 00 00 
  return ioapic->data;
801023f9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023ff:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102402:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102408:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010240e:	0f b6 15 80 27 19 80 	movzbl 0x80192780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102415:	c1 ee 10             	shr    $0x10,%esi
80102418:	89 f0                	mov    %esi,%eax
8010241a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010241d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102420:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102423:	39 c2                	cmp    %eax,%edx
80102425:	74 16                	je     8010243d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102427:	83 ec 0c             	sub    $0xc,%esp
8010242a:	68 b4 7c 10 80       	push   $0x80107cb4
8010242f:	e8 6c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102434:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010243a:	83 c4 10             	add    $0x10,%esp
8010243d:	83 c6 21             	add    $0x21,%esi
{
80102440:	ba 10 00 00 00       	mov    $0x10,%edx
80102445:	b8 20 00 00 00       	mov    $0x20,%eax
8010244a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102450:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102452:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102454:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010245a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010245d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102463:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102466:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102469:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010246c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010246e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102474:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010247b:	39 f0                	cmp    %esi,%eax
8010247d:	75 d1                	jne    80102450 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010247f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102482:	5b                   	pop    %ebx
80102483:	5e                   	pop    %esi
80102484:	5d                   	pop    %ebp
80102485:	c3                   	ret    
80102486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010248d:	8d 76 00             	lea    0x0(%esi),%esi

80102490 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102490:	55                   	push   %ebp
  ioapic->reg = reg;
80102491:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102497:	89 e5                	mov    %esp,%ebp
80102499:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010249c:	8d 50 20             	lea    0x20(%eax),%edx
8010249f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024ae:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024b6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024bb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024be:	89 50 10             	mov    %edx,0x10(%eax)
}
801024c1:	5d                   	pop    %ebp
801024c2:	c3                   	ret    
801024c3:	66 90                	xchg   %ax,%ax
801024c5:	66 90                	xchg   %ax,%ax
801024c7:	66 90                	xchg   %ax,%ax
801024c9:	66 90                	xchg   %ax,%ax
801024cb:	66 90                	xchg   %ax,%ax
801024cd:	66 90                	xchg   %ax,%ax
801024cf:	90                   	nop

801024d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	53                   	push   %ebx
801024d4:	83 ec 04             	sub    $0x4,%esp
801024d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024e0:	0f 85 92 00 00 00    	jne    80102578 <kfree+0xa8>
801024e6:	81 fb d0 b5 19 80    	cmp    $0x8019b5d0,%ebx
801024ec:	0f 82 86 00 00 00    	jb     80102578 <kfree+0xa8>
801024f2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024f8:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024fd:	77 79                	ja     80102578 <kfree+0xa8>
    panic("kfree");

  // OUR MODS
  if(kmem.use_lock != 0) {
801024ff:	8b 0d 74 26 19 80    	mov    0x80192674,%ecx
80102505:	85 c9                	test   %ecx,%ecx
80102507:	74 0c                	je     80102515 <kfree+0x45>
    reference_count[V2P(v) / PGSIZE]--;
80102509:	c1 e8 0c             	shr    $0xc,%eax
    if(reference_count[V2P(v) / PGSIZE] > 0) return;
8010250c:	80 a8 40 26 11 80 01 	subb   $0x1,-0x7feed9c0(%eax)
80102513:	75 33                	jne    80102548 <kfree+0x78>
  }

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102515:	83 ec 04             	sub    $0x4,%esp
80102518:	68 00 10 00 00       	push   $0x1000
8010251d:	6a 01                	push   $0x1
8010251f:	53                   	push   %ebx
80102520:	e8 ab 22 00 00       	call   801047d0 <memset>

  if(kmem.use_lock)
80102525:	8b 15 74 26 19 80    	mov    0x80192674,%edx
8010252b:	83 c4 10             	add    $0x10,%esp
8010252e:	85 d2                	test   %edx,%edx
80102530:	75 1e                	jne    80102550 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102532:	a1 78 26 19 80       	mov    0x80192678,%eax
80102537:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102539:	a1 74 26 19 80       	mov    0x80192674,%eax
  kmem.freelist = r;
8010253e:	89 1d 78 26 19 80    	mov    %ebx,0x80192678
  if(kmem.use_lock)
80102544:	85 c0                	test   %eax,%eax
80102546:	75 20                	jne    80102568 <kfree+0x98>
    release(&kmem.lock);
}
80102548:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010254b:	c9                   	leave  
8010254c:	c3                   	ret    
8010254d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102550:	83 ec 0c             	sub    $0xc,%esp
80102553:	68 40 26 19 80       	push   $0x80192640
80102558:	e8 b3 21 00 00       	call   80104710 <acquire>
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	eb d0                	jmp    80102532 <kfree+0x62>
80102562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102568:	c7 45 08 40 26 19 80 	movl   $0x80192640,0x8(%ebp)
}
8010256f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102572:	c9                   	leave  
    release(&kmem.lock);
80102573:	e9 38 21 00 00       	jmp    801046b0 <release>
    panic("kfree");
80102578:	83 ec 0c             	sub    $0xc,%esp
8010257b:	68 e6 7c 10 80       	push   $0x80107ce6
80102580:	e8 fb dd ff ff       	call   80100380 <panic>
80102585:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010258c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102590 <freerange>:
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102594:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102597:	8b 75 0c             	mov    0xc(%ebp),%esi
8010259a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010259b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025ad:	39 de                	cmp    %ebx,%esi
801025af:	72 23                	jb     801025d4 <freerange+0x44>
801025b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025c7:	50                   	push   %eax
801025c8:	e8 03 ff ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025cd:	83 c4 10             	add    $0x10,%esp
801025d0:	39 f3                	cmp    %esi,%ebx
801025d2:	76 e4                	jbe    801025b8 <freerange+0x28>
}
801025d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d7:	5b                   	pop    %ebx
801025d8:	5e                   	pop    %esi
801025d9:	5d                   	pop    %ebp
801025da:	c3                   	ret    
801025db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025df:	90                   	nop

801025e0 <kinit2>:
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025e4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025e7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ea:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025fd:	39 de                	cmp    %ebx,%esi
801025ff:	72 23                	jb     80102624 <kinit2+0x44>
80102601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102617:	50                   	push   %eax
80102618:	e8 b3 fe ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	39 de                	cmp    %ebx,%esi
80102622:	73 e4                	jae    80102608 <kinit2+0x28>
  kmem.use_lock = 1;
80102624:	c7 05 74 26 19 80 01 	movl   $0x1,0x80192674
8010262b:	00 00 00 
}
8010262e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102631:	5b                   	pop    %ebx
80102632:	5e                   	pop    %esi
80102633:	5d                   	pop    %ebp
80102634:	c3                   	ret    
80102635:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010263c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102640 <kinit1>:
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	56                   	push   %esi
80102644:	53                   	push   %ebx
80102645:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102648:	83 ec 08             	sub    $0x8,%esp
8010264b:	68 ec 7c 10 80       	push   $0x80107cec
80102650:	68 40 26 19 80       	push   $0x80192640
80102655:	e8 e6 1e 00 00       	call   80104540 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010265a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010265d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102660:	c7 05 74 26 19 80 00 	movl   $0x0,0x80192674
80102667:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010266a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102670:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102676:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010267c:	39 de                	cmp    %ebx,%esi
8010267e:	72 1c                	jb     8010269c <kinit1+0x5c>
    kfree(p);
80102680:	83 ec 0c             	sub    $0xc,%esp
80102683:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102689:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010268f:	50                   	push   %eax
80102690:	e8 3b fe ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102695:	83 c4 10             	add    $0x10,%esp
80102698:	39 de                	cmp    %ebx,%esi
8010269a:	73 e4                	jae    80102680 <kinit1+0x40>
}
8010269c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010269f:	5b                   	pop    %ebx
801026a0:	5e                   	pop    %esi
801026a1:	5d                   	pop    %ebp
801026a2:	c3                   	ret    
801026a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801026b0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801026b0:	a1 74 26 19 80       	mov    0x80192674,%eax
801026b5:	85 c0                	test   %eax,%eax
801026b7:	75 1f                	jne    801026d8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026b9:	a1 78 26 19 80       	mov    0x80192678,%eax
  if(r)
801026be:	85 c0                	test   %eax,%eax
801026c0:	74 0e                	je     801026d0 <kalloc+0x20>
    kmem.freelist = r->next;
801026c2:	8b 10                	mov    (%eax),%edx
801026c4:	89 15 78 26 19 80    	mov    %edx,0x80192678
  if(kmem.use_lock)
801026ca:	c3                   	ret    
801026cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026cf:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026d0:	c3                   	ret    
801026d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026d8:	55                   	push   %ebp
801026d9:	89 e5                	mov    %esp,%ebp
801026db:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026de:	68 40 26 19 80       	push   $0x80192640
801026e3:	e8 28 20 00 00       	call   80104710 <acquire>
  r = kmem.freelist;
801026e8:	a1 78 26 19 80       	mov    0x80192678,%eax
  if(kmem.use_lock)
801026ed:	8b 15 74 26 19 80    	mov    0x80192674,%edx
  if(r)
801026f3:	83 c4 10             	add    $0x10,%esp
801026f6:	85 c0                	test   %eax,%eax
801026f8:	74 08                	je     80102702 <kalloc+0x52>
    kmem.freelist = r->next;
801026fa:	8b 08                	mov    (%eax),%ecx
801026fc:	89 0d 78 26 19 80    	mov    %ecx,0x80192678
  if(kmem.use_lock)
80102702:	85 d2                	test   %edx,%edx
80102704:	74 16                	je     8010271c <kalloc+0x6c>
    release(&kmem.lock);
80102706:	83 ec 0c             	sub    $0xc,%esp
80102709:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010270c:	68 40 26 19 80       	push   $0x80192640
80102711:	e8 9a 1f 00 00       	call   801046b0 <release>
  return (char*)r;
80102716:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102719:	83 c4 10             	add    $0x10,%esp
}
8010271c:	c9                   	leave  
8010271d:	c3                   	ret    
8010271e:	66 90                	xchg   %ax,%ax

80102720 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102720:	ba 64 00 00 00       	mov    $0x64,%edx
80102725:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102726:	a8 01                	test   $0x1,%al
80102728:	0f 84 c2 00 00 00    	je     801027f0 <kbdgetc+0xd0>
{
8010272e:	55                   	push   %ebp
8010272f:	ba 60 00 00 00       	mov    $0x60,%edx
80102734:	89 e5                	mov    %esp,%ebp
80102736:	53                   	push   %ebx
80102737:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102738:	8b 1d 7c 26 19 80    	mov    0x8019267c,%ebx
  data = inb(KBDATAP);
8010273e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102741:	3c e0                	cmp    $0xe0,%al
80102743:	74 5b                	je     801027a0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102745:	89 da                	mov    %ebx,%edx
80102747:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010274a:	84 c0                	test   %al,%al
8010274c:	78 62                	js     801027b0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010274e:	85 d2                	test   %edx,%edx
80102750:	74 09                	je     8010275b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102752:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102755:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102758:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010275b:	0f b6 91 20 7e 10 80 	movzbl -0x7fef81e0(%ecx),%edx
  shift ^= togglecode[data];
80102762:	0f b6 81 20 7d 10 80 	movzbl -0x7fef82e0(%ecx),%eax
  shift |= shiftcode[data];
80102769:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010276b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010276d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010276f:	89 15 7c 26 19 80    	mov    %edx,0x8019267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102775:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102778:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010277b:	8b 04 85 00 7d 10 80 	mov    -0x7fef8300(,%eax,4),%eax
80102782:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102786:	74 0b                	je     80102793 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102788:	8d 50 9f             	lea    -0x61(%eax),%edx
8010278b:	83 fa 19             	cmp    $0x19,%edx
8010278e:	77 48                	ja     801027d8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102790:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102793:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102796:	c9                   	leave  
80102797:	c3                   	ret    
80102798:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010279f:	90                   	nop
    shift |= E0ESC;
801027a0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801027a3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801027a5:	89 1d 7c 26 19 80    	mov    %ebx,0x8019267c
}
801027ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027ae:	c9                   	leave  
801027af:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801027b0:	83 e0 7f             	and    $0x7f,%eax
801027b3:	85 d2                	test   %edx,%edx
801027b5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801027b8:	0f b6 81 20 7e 10 80 	movzbl -0x7fef81e0(%ecx),%eax
801027bf:	83 c8 40             	or     $0x40,%eax
801027c2:	0f b6 c0             	movzbl %al,%eax
801027c5:	f7 d0                	not    %eax
801027c7:	21 d8                	and    %ebx,%eax
}
801027c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801027cc:	a3 7c 26 19 80       	mov    %eax,0x8019267c
    return 0;
801027d1:	31 c0                	xor    %eax,%eax
}
801027d3:	c9                   	leave  
801027d4:	c3                   	ret    
801027d5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027d8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027db:	8d 50 20             	lea    0x20(%eax),%edx
}
801027de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027e1:	c9                   	leave  
      c += 'a' - 'A';
801027e2:	83 f9 1a             	cmp    $0x1a,%ecx
801027e5:	0f 42 c2             	cmovb  %edx,%eax
}
801027e8:	c3                   	ret    
801027e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027f5:	c3                   	ret    
801027f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027fd:	8d 76 00             	lea    0x0(%esi),%esi

80102800 <kbdintr>:

void
kbdintr(void)
{
80102800:	55                   	push   %ebp
80102801:	89 e5                	mov    %esp,%ebp
80102803:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102806:	68 20 27 10 80       	push   $0x80102720
8010280b:	e8 70 e0 ff ff       	call   80100880 <consoleintr>
}
80102810:	83 c4 10             	add    $0x10,%esp
80102813:	c9                   	leave  
80102814:	c3                   	ret    
80102815:	66 90                	xchg   %ax,%ax
80102817:	66 90                	xchg   %ax,%ax
80102819:	66 90                	xchg   %ax,%ax
8010281b:	66 90                	xchg   %ax,%ax
8010281d:	66 90                	xchg   %ax,%ax
8010281f:	90                   	nop

80102820 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102820:	a1 80 26 19 80       	mov    0x80192680,%eax
80102825:	85 c0                	test   %eax,%eax
80102827:	0f 84 cb 00 00 00    	je     801028f8 <lapicinit+0xd8>
  lapic[index] = value;
8010282d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102834:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102837:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102841:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102844:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102847:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010284e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102851:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102854:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010285b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010285e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102861:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102868:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010286b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010286e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102875:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102878:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010287b:	8b 50 30             	mov    0x30(%eax),%edx
8010287e:	c1 ea 10             	shr    $0x10,%edx
80102881:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102887:	75 77                	jne    80102900 <lapicinit+0xe0>
  lapic[index] = value;
80102889:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102890:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102893:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102896:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010289d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028aa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ad:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028b0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028b7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ba:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028bd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ca:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028d1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028d4:	8b 50 20             	mov    0x20(%eax),%edx
801028d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028de:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028e0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028e6:	80 e6 10             	and    $0x10,%dh
801028e9:	75 f5                	jne    801028e0 <lapicinit+0xc0>
  lapic[index] = value;
801028eb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028f2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028f5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028f8:	c3                   	ret    
801028f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102900:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102907:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010290a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010290d:	e9 77 ff ff ff       	jmp    80102889 <lapicinit+0x69>
80102912:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102920 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102920:	a1 80 26 19 80       	mov    0x80192680,%eax
80102925:	85 c0                	test   %eax,%eax
80102927:	74 07                	je     80102930 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102929:	8b 40 20             	mov    0x20(%eax),%eax
8010292c:	c1 e8 18             	shr    $0x18,%eax
8010292f:	c3                   	ret    
    return 0;
80102930:	31 c0                	xor    %eax,%eax
}
80102932:	c3                   	ret    
80102933:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102940 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102940:	a1 80 26 19 80       	mov    0x80192680,%eax
80102945:	85 c0                	test   %eax,%eax
80102947:	74 0d                	je     80102956 <lapiceoi+0x16>
  lapic[index] = value;
80102949:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102950:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102953:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102956:	c3                   	ret    
80102957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010295e:	66 90                	xchg   %ax,%ax

80102960 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102960:	c3                   	ret    
80102961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102968:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010296f:	90                   	nop

80102970 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102970:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102971:	b8 0f 00 00 00       	mov    $0xf,%eax
80102976:	ba 70 00 00 00       	mov    $0x70,%edx
8010297b:	89 e5                	mov    %esp,%ebp
8010297d:	53                   	push   %ebx
8010297e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102981:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102984:	ee                   	out    %al,(%dx)
80102985:	b8 0a 00 00 00       	mov    $0xa,%eax
8010298a:	ba 71 00 00 00       	mov    $0x71,%edx
8010298f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102990:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102992:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102995:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010299b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010299d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801029a0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801029a2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801029a5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801029a8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801029ae:	a1 80 26 19 80       	mov    0x80192680,%eax
801029b3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029bc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029c3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029c9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029d0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029d6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029dc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029df:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029e5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029e8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029f1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029f7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029fd:	c9                   	leave  
801029fe:	c3                   	ret    
801029ff:	90                   	nop

80102a00 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a00:	55                   	push   %ebp
80102a01:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a06:	ba 70 00 00 00       	mov    $0x70,%edx
80102a0b:	89 e5                	mov    %esp,%ebp
80102a0d:	57                   	push   %edi
80102a0e:	56                   	push   %esi
80102a0f:	53                   	push   %ebx
80102a10:	83 ec 4c             	sub    $0x4c,%esp
80102a13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a14:	ba 71 00 00 00       	mov    $0x71,%edx
80102a19:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a1a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a1d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a22:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a25:	8d 76 00             	lea    0x0(%esi),%esi
80102a28:	31 c0                	xor    %eax,%eax
80102a2a:	89 da                	mov    %ebx,%edx
80102a2c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a32:	89 ca                	mov    %ecx,%edx
80102a34:	ec                   	in     (%dx),%al
80102a35:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a38:	89 da                	mov    %ebx,%edx
80102a3a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a3f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a40:	89 ca                	mov    %ecx,%edx
80102a42:	ec                   	in     (%dx),%al
80102a43:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a46:	89 da                	mov    %ebx,%edx
80102a48:	b8 04 00 00 00       	mov    $0x4,%eax
80102a4d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4e:	89 ca                	mov    %ecx,%edx
80102a50:	ec                   	in     (%dx),%al
80102a51:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a54:	89 da                	mov    %ebx,%edx
80102a56:	b8 07 00 00 00       	mov    $0x7,%eax
80102a5b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a5c:	89 ca                	mov    %ecx,%edx
80102a5e:	ec                   	in     (%dx),%al
80102a5f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a62:	89 da                	mov    %ebx,%edx
80102a64:	b8 08 00 00 00       	mov    $0x8,%eax
80102a69:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6a:	89 ca                	mov    %ecx,%edx
80102a6c:	ec                   	in     (%dx),%al
80102a6d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6f:	89 da                	mov    %ebx,%edx
80102a71:	b8 09 00 00 00       	mov    $0x9,%eax
80102a76:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a77:	89 ca                	mov    %ecx,%edx
80102a79:	ec                   	in     (%dx),%al
80102a7a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7c:	89 da                	mov    %ebx,%edx
80102a7e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a83:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a84:	89 ca                	mov    %ecx,%edx
80102a86:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a87:	84 c0                	test   %al,%al
80102a89:	78 9d                	js     80102a28 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a8b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a8f:	89 fa                	mov    %edi,%edx
80102a91:	0f b6 fa             	movzbl %dl,%edi
80102a94:	89 f2                	mov    %esi,%edx
80102a96:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a99:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a9d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa0:	89 da                	mov    %ebx,%edx
80102aa2:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102aa5:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102aa8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102aac:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102aaf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102ab2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ab6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ab9:	31 c0                	xor    %eax,%eax
80102abb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abc:	89 ca                	mov    %ecx,%edx
80102abe:	ec                   	in     (%dx),%al
80102abf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac2:	89 da                	mov    %ebx,%edx
80102ac4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ac7:	b8 02 00 00 00       	mov    $0x2,%eax
80102acc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102acd:	89 ca                	mov    %ecx,%edx
80102acf:	ec                   	in     (%dx),%al
80102ad0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad3:	89 da                	mov    %ebx,%edx
80102ad5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ad8:	b8 04 00 00 00       	mov    $0x4,%eax
80102add:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ade:	89 ca                	mov    %ecx,%edx
80102ae0:	ec                   	in     (%dx),%al
80102ae1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae4:	89 da                	mov    %ebx,%edx
80102ae6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ae9:	b8 07 00 00 00       	mov    $0x7,%eax
80102aee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aef:	89 ca                	mov    %ecx,%edx
80102af1:	ec                   	in     (%dx),%al
80102af2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af5:	89 da                	mov    %ebx,%edx
80102af7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102afa:	b8 08 00 00 00       	mov    $0x8,%eax
80102aff:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b00:	89 ca                	mov    %ecx,%edx
80102b02:	ec                   	in     (%dx),%al
80102b03:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b06:	89 da                	mov    %ebx,%edx
80102b08:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b0b:	b8 09 00 00 00       	mov    $0x9,%eax
80102b10:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b11:	89 ca                	mov    %ecx,%edx
80102b13:	ec                   	in     (%dx),%al
80102b14:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b17:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b1d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b20:	6a 18                	push   $0x18
80102b22:	50                   	push   %eax
80102b23:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b26:	50                   	push   %eax
80102b27:	e8 f4 1c 00 00       	call   80104820 <memcmp>
80102b2c:	83 c4 10             	add    $0x10,%esp
80102b2f:	85 c0                	test   %eax,%eax
80102b31:	0f 85 f1 fe ff ff    	jne    80102a28 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b37:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b3b:	75 78                	jne    80102bb5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b3d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b40:	89 c2                	mov    %eax,%edx
80102b42:	83 e0 0f             	and    $0xf,%eax
80102b45:	c1 ea 04             	shr    $0x4,%edx
80102b48:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b4b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b4e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b51:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b54:	89 c2                	mov    %eax,%edx
80102b56:	83 e0 0f             	and    $0xf,%eax
80102b59:	c1 ea 04             	shr    $0x4,%edx
80102b5c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b5f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b62:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b65:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b68:	89 c2                	mov    %eax,%edx
80102b6a:	83 e0 0f             	and    $0xf,%eax
80102b6d:	c1 ea 04             	shr    $0x4,%edx
80102b70:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b73:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b76:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b7c:	89 c2                	mov    %eax,%edx
80102b7e:	83 e0 0f             	and    $0xf,%eax
80102b81:	c1 ea 04             	shr    $0x4,%edx
80102b84:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b87:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b8a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b8d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b90:	89 c2                	mov    %eax,%edx
80102b92:	83 e0 0f             	and    $0xf,%eax
80102b95:	c1 ea 04             	shr    $0x4,%edx
80102b98:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b9b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b9e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102ba1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ba4:	89 c2                	mov    %eax,%edx
80102ba6:	83 e0 0f             	and    $0xf,%eax
80102ba9:	c1 ea 04             	shr    $0x4,%edx
80102bac:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102baf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bb2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102bb5:	8b 75 08             	mov    0x8(%ebp),%esi
80102bb8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bbb:	89 06                	mov    %eax,(%esi)
80102bbd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bc0:	89 46 04             	mov    %eax,0x4(%esi)
80102bc3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bc6:	89 46 08             	mov    %eax,0x8(%esi)
80102bc9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bcc:	89 46 0c             	mov    %eax,0xc(%esi)
80102bcf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bd2:	89 46 10             	mov    %eax,0x10(%esi)
80102bd5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bd8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bdb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102be2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102be5:	5b                   	pop    %ebx
80102be6:	5e                   	pop    %esi
80102be7:	5f                   	pop    %edi
80102be8:	5d                   	pop    %ebp
80102be9:	c3                   	ret    
80102bea:	66 90                	xchg   %ax,%ax
80102bec:	66 90                	xchg   %ax,%ax
80102bee:	66 90                	xchg   %ax,%ax

80102bf0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bf0:	8b 0d e8 26 19 80    	mov    0x801926e8,%ecx
80102bf6:	85 c9                	test   %ecx,%ecx
80102bf8:	0f 8e 8a 00 00 00    	jle    80102c88 <install_trans+0x98>
{
80102bfe:	55                   	push   %ebp
80102bff:	89 e5                	mov    %esp,%ebp
80102c01:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c02:	31 ff                	xor    %edi,%edi
{
80102c04:	56                   	push   %esi
80102c05:	53                   	push   %ebx
80102c06:	83 ec 0c             	sub    $0xc,%esp
80102c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c10:	a1 d4 26 19 80       	mov    0x801926d4,%eax
80102c15:	83 ec 08             	sub    $0x8,%esp
80102c18:	01 f8                	add    %edi,%eax
80102c1a:	83 c0 01             	add    $0x1,%eax
80102c1d:	50                   	push   %eax
80102c1e:	ff 35 e4 26 19 80    	push   0x801926e4
80102c24:	e8 a7 d4 ff ff       	call   801000d0 <bread>
80102c29:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c2b:	58                   	pop    %eax
80102c2c:	5a                   	pop    %edx
80102c2d:	ff 34 bd ec 26 19 80 	push   -0x7fe6d914(,%edi,4)
80102c34:	ff 35 e4 26 19 80    	push   0x801926e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c3a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c3d:	e8 8e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c42:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c45:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c47:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c4a:	68 00 02 00 00       	push   $0x200
80102c4f:	50                   	push   %eax
80102c50:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c53:	50                   	push   %eax
80102c54:	e8 17 1c 00 00       	call   80104870 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c59:	89 1c 24             	mov    %ebx,(%esp)
80102c5c:	e8 4f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c61:	89 34 24             	mov    %esi,(%esp)
80102c64:	e8 87 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c69:	89 1c 24             	mov    %ebx,(%esp)
80102c6c:	e8 7f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c71:	83 c4 10             	add    $0x10,%esp
80102c74:	39 3d e8 26 19 80    	cmp    %edi,0x801926e8
80102c7a:	7f 94                	jg     80102c10 <install_trans+0x20>
  }
}
80102c7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c7f:	5b                   	pop    %ebx
80102c80:	5e                   	pop    %esi
80102c81:	5f                   	pop    %edi
80102c82:	5d                   	pop    %ebp
80102c83:	c3                   	ret    
80102c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c88:	c3                   	ret    
80102c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c90 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c90:	55                   	push   %ebp
80102c91:	89 e5                	mov    %esp,%ebp
80102c93:	53                   	push   %ebx
80102c94:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c97:	ff 35 d4 26 19 80    	push   0x801926d4
80102c9d:	ff 35 e4 26 19 80    	push   0x801926e4
80102ca3:	e8 28 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ca8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cab:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102cad:	a1 e8 26 19 80       	mov    0x801926e8,%eax
80102cb2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102cb5:	85 c0                	test   %eax,%eax
80102cb7:	7e 19                	jle    80102cd2 <write_head+0x42>
80102cb9:	31 d2                	xor    %edx,%edx
80102cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cbf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102cc0:	8b 0c 95 ec 26 19 80 	mov    -0x7fe6d914(,%edx,4),%ecx
80102cc7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ccb:	83 c2 01             	add    $0x1,%edx
80102cce:	39 d0                	cmp    %edx,%eax
80102cd0:	75 ee                	jne    80102cc0 <write_head+0x30>
  }
  bwrite(buf);
80102cd2:	83 ec 0c             	sub    $0xc,%esp
80102cd5:	53                   	push   %ebx
80102cd6:	e8 d5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cdb:	89 1c 24             	mov    %ebx,(%esp)
80102cde:	e8 0d d5 ff ff       	call   801001f0 <brelse>
}
80102ce3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ce6:	83 c4 10             	add    $0x10,%esp
80102ce9:	c9                   	leave  
80102cea:	c3                   	ret    
80102ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cef:	90                   	nop

80102cf0 <initlog>:
{
80102cf0:	55                   	push   %ebp
80102cf1:	89 e5                	mov    %esp,%ebp
80102cf3:	53                   	push   %ebx
80102cf4:	83 ec 2c             	sub    $0x2c,%esp
80102cf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cfa:	68 20 7f 10 80       	push   $0x80107f20
80102cff:	68 a0 26 19 80       	push   $0x801926a0
80102d04:	e8 37 18 00 00       	call   80104540 <initlock>
  readsb(dev, &sb);
80102d09:	58                   	pop    %eax
80102d0a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d0d:	5a                   	pop    %edx
80102d0e:	50                   	push   %eax
80102d0f:	53                   	push   %ebx
80102d10:	e8 1b e8 ff ff       	call   80101530 <readsb>
  log.start = sb.logstart;
80102d15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d18:	59                   	pop    %ecx
  log.dev = dev;
80102d19:	89 1d e4 26 19 80    	mov    %ebx,0x801926e4
  log.size = sb.nlog;
80102d1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d22:	a3 d4 26 19 80       	mov    %eax,0x801926d4
  log.size = sb.nlog;
80102d27:	89 15 d8 26 19 80    	mov    %edx,0x801926d8
  struct buf *buf = bread(log.dev, log.start);
80102d2d:	5a                   	pop    %edx
80102d2e:	50                   	push   %eax
80102d2f:	53                   	push   %ebx
80102d30:	e8 9b d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d35:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d38:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d3b:	89 1d e8 26 19 80    	mov    %ebx,0x801926e8
  for (i = 0; i < log.lh.n; i++) {
80102d41:	85 db                	test   %ebx,%ebx
80102d43:	7e 1d                	jle    80102d62 <initlog+0x72>
80102d45:	31 d2                	xor    %edx,%edx
80102d47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d4e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d50:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d54:	89 0c 95 ec 26 19 80 	mov    %ecx,-0x7fe6d914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d5b:	83 c2 01             	add    $0x1,%edx
80102d5e:	39 d3                	cmp    %edx,%ebx
80102d60:	75 ee                	jne    80102d50 <initlog+0x60>
  brelse(buf);
80102d62:	83 ec 0c             	sub    $0xc,%esp
80102d65:	50                   	push   %eax
80102d66:	e8 85 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d6b:	e8 80 fe ff ff       	call   80102bf0 <install_trans>
  log.lh.n = 0;
80102d70:	c7 05 e8 26 19 80 00 	movl   $0x0,0x801926e8
80102d77:	00 00 00 
  write_head(); // clear the log
80102d7a:	e8 11 ff ff ff       	call   80102c90 <write_head>
}
80102d7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d82:	83 c4 10             	add    $0x10,%esp
80102d85:	c9                   	leave  
80102d86:	c3                   	ret    
80102d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d8e:	66 90                	xchg   %ax,%ax

80102d90 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d96:	68 a0 26 19 80       	push   $0x801926a0
80102d9b:	e8 70 19 00 00       	call   80104710 <acquire>
80102da0:	83 c4 10             	add    $0x10,%esp
80102da3:	eb 18                	jmp    80102dbd <begin_op+0x2d>
80102da5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102da8:	83 ec 08             	sub    $0x8,%esp
80102dab:	68 a0 26 19 80       	push   $0x801926a0
80102db0:	68 a0 26 19 80       	push   $0x801926a0
80102db5:	e8 f6 13 00 00       	call   801041b0 <sleep>
80102dba:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102dbd:	a1 e0 26 19 80       	mov    0x801926e0,%eax
80102dc2:	85 c0                	test   %eax,%eax
80102dc4:	75 e2                	jne    80102da8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102dc6:	a1 dc 26 19 80       	mov    0x801926dc,%eax
80102dcb:	8b 15 e8 26 19 80    	mov    0x801926e8,%edx
80102dd1:	83 c0 01             	add    $0x1,%eax
80102dd4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102dd7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dda:	83 fa 1e             	cmp    $0x1e,%edx
80102ddd:	7f c9                	jg     80102da8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102ddf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102de2:	a3 dc 26 19 80       	mov    %eax,0x801926dc
      release(&log.lock);
80102de7:	68 a0 26 19 80       	push   $0x801926a0
80102dec:	e8 bf 18 00 00       	call   801046b0 <release>
      break;
    }
  }
}
80102df1:	83 c4 10             	add    $0x10,%esp
80102df4:	c9                   	leave  
80102df5:	c3                   	ret    
80102df6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dfd:	8d 76 00             	lea    0x0(%esi),%esi

80102e00 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	57                   	push   %edi
80102e04:	56                   	push   %esi
80102e05:	53                   	push   %ebx
80102e06:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e09:	68 a0 26 19 80       	push   $0x801926a0
80102e0e:	e8 fd 18 00 00       	call   80104710 <acquire>
  log.outstanding -= 1;
80102e13:	a1 dc 26 19 80       	mov    0x801926dc,%eax
  if(log.committing)
80102e18:	8b 35 e0 26 19 80    	mov    0x801926e0,%esi
80102e1e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e21:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e24:	89 1d dc 26 19 80    	mov    %ebx,0x801926dc
  if(log.committing)
80102e2a:	85 f6                	test   %esi,%esi
80102e2c:	0f 85 22 01 00 00    	jne    80102f54 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e32:	85 db                	test   %ebx,%ebx
80102e34:	0f 85 f6 00 00 00    	jne    80102f30 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e3a:	c7 05 e0 26 19 80 01 	movl   $0x1,0x801926e0
80102e41:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e44:	83 ec 0c             	sub    $0xc,%esp
80102e47:	68 a0 26 19 80       	push   $0x801926a0
80102e4c:	e8 5f 18 00 00       	call   801046b0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e51:	8b 0d e8 26 19 80    	mov    0x801926e8,%ecx
80102e57:	83 c4 10             	add    $0x10,%esp
80102e5a:	85 c9                	test   %ecx,%ecx
80102e5c:	7f 42                	jg     80102ea0 <end_op+0xa0>
    acquire(&log.lock);
80102e5e:	83 ec 0c             	sub    $0xc,%esp
80102e61:	68 a0 26 19 80       	push   $0x801926a0
80102e66:	e8 a5 18 00 00       	call   80104710 <acquire>
    wakeup(&log);
80102e6b:	c7 04 24 a0 26 19 80 	movl   $0x801926a0,(%esp)
    log.committing = 0;
80102e72:	c7 05 e0 26 19 80 00 	movl   $0x0,0x801926e0
80102e79:	00 00 00 
    wakeup(&log);
80102e7c:	e8 ef 13 00 00       	call   80104270 <wakeup>
    release(&log.lock);
80102e81:	c7 04 24 a0 26 19 80 	movl   $0x801926a0,(%esp)
80102e88:	e8 23 18 00 00       	call   801046b0 <release>
80102e8d:	83 c4 10             	add    $0x10,%esp
}
80102e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e93:	5b                   	pop    %ebx
80102e94:	5e                   	pop    %esi
80102e95:	5f                   	pop    %edi
80102e96:	5d                   	pop    %ebp
80102e97:	c3                   	ret    
80102e98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e9f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ea0:	a1 d4 26 19 80       	mov    0x801926d4,%eax
80102ea5:	83 ec 08             	sub    $0x8,%esp
80102ea8:	01 d8                	add    %ebx,%eax
80102eaa:	83 c0 01             	add    $0x1,%eax
80102ead:	50                   	push   %eax
80102eae:	ff 35 e4 26 19 80    	push   0x801926e4
80102eb4:	e8 17 d2 ff ff       	call   801000d0 <bread>
80102eb9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ebb:	58                   	pop    %eax
80102ebc:	5a                   	pop    %edx
80102ebd:	ff 34 9d ec 26 19 80 	push   -0x7fe6d914(,%ebx,4)
80102ec4:	ff 35 e4 26 19 80    	push   0x801926e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eca:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ecd:	e8 fe d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ed2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ed5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ed7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eda:	68 00 02 00 00       	push   $0x200
80102edf:	50                   	push   %eax
80102ee0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ee3:	50                   	push   %eax
80102ee4:	e8 87 19 00 00       	call   80104870 <memmove>
    bwrite(to);  // write the log
80102ee9:	89 34 24             	mov    %esi,(%esp)
80102eec:	e8 bf d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ef1:	89 3c 24             	mov    %edi,(%esp)
80102ef4:	e8 f7 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ef9:	89 34 24             	mov    %esi,(%esp)
80102efc:	e8 ef d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f01:	83 c4 10             	add    $0x10,%esp
80102f04:	3b 1d e8 26 19 80    	cmp    0x801926e8,%ebx
80102f0a:	7c 94                	jl     80102ea0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f0c:	e8 7f fd ff ff       	call   80102c90 <write_head>
    install_trans(); // Now install writes to home locations
80102f11:	e8 da fc ff ff       	call   80102bf0 <install_trans>
    log.lh.n = 0;
80102f16:	c7 05 e8 26 19 80 00 	movl   $0x0,0x801926e8
80102f1d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f20:	e8 6b fd ff ff       	call   80102c90 <write_head>
80102f25:	e9 34 ff ff ff       	jmp    80102e5e <end_op+0x5e>
80102f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f30:	83 ec 0c             	sub    $0xc,%esp
80102f33:	68 a0 26 19 80       	push   $0x801926a0
80102f38:	e8 33 13 00 00       	call   80104270 <wakeup>
  release(&log.lock);
80102f3d:	c7 04 24 a0 26 19 80 	movl   $0x801926a0,(%esp)
80102f44:	e8 67 17 00 00       	call   801046b0 <release>
80102f49:	83 c4 10             	add    $0x10,%esp
}
80102f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f4f:	5b                   	pop    %ebx
80102f50:	5e                   	pop    %esi
80102f51:	5f                   	pop    %edi
80102f52:	5d                   	pop    %ebp
80102f53:	c3                   	ret    
    panic("log.committing");
80102f54:	83 ec 0c             	sub    $0xc,%esp
80102f57:	68 24 7f 10 80       	push   $0x80107f24
80102f5c:	e8 1f d4 ff ff       	call   80100380 <panic>
80102f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f6f:	90                   	nop

80102f70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	53                   	push   %ebx
80102f74:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f77:	8b 15 e8 26 19 80    	mov    0x801926e8,%edx
{
80102f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f80:	83 fa 1d             	cmp    $0x1d,%edx
80102f83:	0f 8f 85 00 00 00    	jg     8010300e <log_write+0x9e>
80102f89:	a1 d8 26 19 80       	mov    0x801926d8,%eax
80102f8e:	83 e8 01             	sub    $0x1,%eax
80102f91:	39 c2                	cmp    %eax,%edx
80102f93:	7d 79                	jge    8010300e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f95:	a1 dc 26 19 80       	mov    0x801926dc,%eax
80102f9a:	85 c0                	test   %eax,%eax
80102f9c:	7e 7d                	jle    8010301b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f9e:	83 ec 0c             	sub    $0xc,%esp
80102fa1:	68 a0 26 19 80       	push   $0x801926a0
80102fa6:	e8 65 17 00 00       	call   80104710 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102fab:	8b 15 e8 26 19 80    	mov    0x801926e8,%edx
80102fb1:	83 c4 10             	add    $0x10,%esp
80102fb4:	85 d2                	test   %edx,%edx
80102fb6:	7e 4a                	jle    80103002 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fb8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102fbb:	31 c0                	xor    %eax,%eax
80102fbd:	eb 08                	jmp    80102fc7 <log_write+0x57>
80102fbf:	90                   	nop
80102fc0:	83 c0 01             	add    $0x1,%eax
80102fc3:	39 c2                	cmp    %eax,%edx
80102fc5:	74 29                	je     80102ff0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fc7:	39 0c 85 ec 26 19 80 	cmp    %ecx,-0x7fe6d914(,%eax,4)
80102fce:	75 f0                	jne    80102fc0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fd0:	89 0c 85 ec 26 19 80 	mov    %ecx,-0x7fe6d914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fd7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fdd:	c7 45 08 a0 26 19 80 	movl   $0x801926a0,0x8(%ebp)
}
80102fe4:	c9                   	leave  
  release(&log.lock);
80102fe5:	e9 c6 16 00 00       	jmp    801046b0 <release>
80102fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102ff0:	89 0c 95 ec 26 19 80 	mov    %ecx,-0x7fe6d914(,%edx,4)
    log.lh.n++;
80102ff7:	83 c2 01             	add    $0x1,%edx
80102ffa:	89 15 e8 26 19 80    	mov    %edx,0x801926e8
80103000:	eb d5                	jmp    80102fd7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103002:	8b 43 08             	mov    0x8(%ebx),%eax
80103005:	a3 ec 26 19 80       	mov    %eax,0x801926ec
  if (i == log.lh.n)
8010300a:	75 cb                	jne    80102fd7 <log_write+0x67>
8010300c:	eb e9                	jmp    80102ff7 <log_write+0x87>
    panic("too big a transaction");
8010300e:	83 ec 0c             	sub    $0xc,%esp
80103011:	68 33 7f 10 80       	push   $0x80107f33
80103016:	e8 65 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010301b:	83 ec 0c             	sub    $0xc,%esp
8010301e:	68 49 7f 10 80       	push   $0x80107f49
80103023:	e8 58 d3 ff ff       	call   80100380 <panic>
80103028:	66 90                	xchg   %ax,%ax
8010302a:	66 90                	xchg   %ax,%ax
8010302c:	66 90                	xchg   %ax,%ax
8010302e:	66 90                	xchg   %ax,%ax

80103030 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103030:	55                   	push   %ebp
80103031:	89 e5                	mov    %esp,%ebp
80103033:	53                   	push   %ebx
80103034:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103037:	e8 64 09 00 00       	call   801039a0 <cpuid>
8010303c:	89 c3                	mov    %eax,%ebx
8010303e:	e8 5d 09 00 00       	call   801039a0 <cpuid>
80103043:	83 ec 04             	sub    $0x4,%esp
80103046:	53                   	push   %ebx
80103047:	50                   	push   %eax
80103048:	68 64 7f 10 80       	push   $0x80107f64
8010304d:	e8 4e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103052:	e8 79 2b 00 00       	call   80105bd0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103057:	e8 e4 08 00 00       	call   80103940 <mycpu>
8010305c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010305e:	b8 01 00 00 00       	mov    $0x1,%eax
80103063:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010306a:	e8 11 0d 00 00       	call   80103d80 <scheduler>
8010306f:	90                   	nop

80103070 <mpenter>:
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103076:	e8 05 3f 00 00       	call   80106f80 <switchkvm>
  seginit();
8010307b:	e8 f0 3c 00 00       	call   80106d70 <seginit>
  lapicinit();
80103080:	e8 9b f7 ff ff       	call   80102820 <lapicinit>
  mpmain();
80103085:	e8 a6 ff ff ff       	call   80103030 <mpmain>
8010308a:	66 90                	xchg   %ax,%ax
8010308c:	66 90                	xchg   %ax,%ax
8010308e:	66 90                	xchg   %ax,%ax

80103090 <main>:
{
80103090:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103094:	83 e4 f0             	and    $0xfffffff0,%esp
80103097:	ff 71 fc             	push   -0x4(%ecx)
8010309a:	55                   	push   %ebp
8010309b:	89 e5                	mov    %esp,%ebp
8010309d:	53                   	push   %ebx
8010309e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010309f:	83 ec 08             	sub    $0x8,%esp
801030a2:	68 00 00 40 80       	push   $0x80400000
801030a7:	68 d0 b5 19 80       	push   $0x8019b5d0
801030ac:	e8 8f f5 ff ff       	call   80102640 <kinit1>
  kvmalloc();      // kernel page table
801030b1:	e8 ba 43 00 00       	call   80107470 <kvmalloc>
  mpinit();        // detect other processors
801030b6:	e8 85 01 00 00       	call   80103240 <mpinit>
  lapicinit();     // interrupt controller
801030bb:	e8 60 f7 ff ff       	call   80102820 <lapicinit>
  seginit();       // segment descriptors
801030c0:	e8 ab 3c 00 00       	call   80106d70 <seginit>
  picinit();       // disable pic
801030c5:	e8 76 03 00 00       	call   80103440 <picinit>
  ioapicinit();    // another interrupt controller
801030ca:	e8 11 f3 ff ff       	call   801023e0 <ioapicinit>
  consoleinit();   // console hardware
801030cf:	e8 8c d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030d4:	e8 17 30 00 00       	call   801060f0 <uartinit>
  pinit();         // process table
801030d9:	e8 42 08 00 00       	call   80103920 <pinit>
  tvinit();        // trap vectors
801030de:	e8 6d 2a 00 00       	call   80105b50 <tvinit>
  binit();         // buffer cache
801030e3:	e8 58 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030e8:	e8 33 dd ff ff       	call   80100e20 <fileinit>
  ideinit();       // disk 
801030ed:	e8 de f0 ff ff       	call   801021d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030f2:	83 c4 0c             	add    $0xc,%esp
801030f5:	68 8a 00 00 00       	push   $0x8a
801030fa:	68 8c b4 10 80       	push   $0x8010b48c
801030ff:	68 00 70 00 80       	push   $0x80007000
80103104:	e8 67 17 00 00       	call   80104870 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103109:	83 c4 10             	add    $0x10,%esp
8010310c:	69 05 84 27 19 80 b0 	imul   $0xb0,0x80192784,%eax
80103113:	00 00 00 
80103116:	05 a0 27 19 80       	add    $0x801927a0,%eax
8010311b:	3d a0 27 19 80       	cmp    $0x801927a0,%eax
80103120:	76 7e                	jbe    801031a0 <main+0x110>
80103122:	bb a0 27 19 80       	mov    $0x801927a0,%ebx
80103127:	eb 20                	jmp    80103149 <main+0xb9>
80103129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103130:	69 05 84 27 19 80 b0 	imul   $0xb0,0x80192784,%eax
80103137:	00 00 00 
8010313a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103140:	05 a0 27 19 80       	add    $0x801927a0,%eax
80103145:	39 c3                	cmp    %eax,%ebx
80103147:	73 57                	jae    801031a0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103149:	e8 f2 07 00 00       	call   80103940 <mycpu>
8010314e:	39 c3                	cmp    %eax,%ebx
80103150:	74 de                	je     80103130 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103152:	e8 59 f5 ff ff       	call   801026b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103157:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010315a:	c7 05 f8 6f 00 80 70 	movl   $0x80103070,0x80006ff8
80103161:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103164:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010316b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010316e:	05 00 10 00 00       	add    $0x1000,%eax
80103173:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103178:	0f b6 03             	movzbl (%ebx),%eax
8010317b:	68 00 70 00 00       	push   $0x7000
80103180:	50                   	push   %eax
80103181:	e8 ea f7 ff ff       	call   80102970 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103186:	83 c4 10             	add    $0x10,%esp
80103189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103190:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103196:	85 c0                	test   %eax,%eax
80103198:	74 f6                	je     80103190 <main+0x100>
8010319a:	eb 94                	jmp    80103130 <main+0xa0>
8010319c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031a0:	83 ec 08             	sub    $0x8,%esp
801031a3:	68 00 00 00 8e       	push   $0x8e000000
801031a8:	68 00 00 40 80       	push   $0x80400000
801031ad:	e8 2e f4 ff ff       	call   801025e0 <kinit2>
  userinit();      // first user process
801031b2:	e8 39 08 00 00       	call   801039f0 <userinit>
  mpmain();        // finish this processor's setup
801031b7:	e8 74 fe ff ff       	call   80103030 <mpmain>
801031bc:	66 90                	xchg   %ax,%ax
801031be:	66 90                	xchg   %ax,%ax

801031c0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031c0:	55                   	push   %ebp
801031c1:	89 e5                	mov    %esp,%ebp
801031c3:	57                   	push   %edi
801031c4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031c5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031cb:	53                   	push   %ebx
  e = addr+len;
801031cc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031cf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031d2:	39 de                	cmp    %ebx,%esi
801031d4:	72 10                	jb     801031e6 <mpsearch1+0x26>
801031d6:	eb 50                	jmp    80103228 <mpsearch1+0x68>
801031d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031df:	90                   	nop
801031e0:	89 fe                	mov    %edi,%esi
801031e2:	39 fb                	cmp    %edi,%ebx
801031e4:	76 42                	jbe    80103228 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e6:	83 ec 04             	sub    $0x4,%esp
801031e9:	8d 7e 10             	lea    0x10(%esi),%edi
801031ec:	6a 04                	push   $0x4
801031ee:	68 78 7f 10 80       	push   $0x80107f78
801031f3:	56                   	push   %esi
801031f4:	e8 27 16 00 00       	call   80104820 <memcmp>
801031f9:	83 c4 10             	add    $0x10,%esp
801031fc:	85 c0                	test   %eax,%eax
801031fe:	75 e0                	jne    801031e0 <mpsearch1+0x20>
80103200:	89 f2                	mov    %esi,%edx
80103202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103208:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010320b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010320e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103210:	39 fa                	cmp    %edi,%edx
80103212:	75 f4                	jne    80103208 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103214:	84 c0                	test   %al,%al
80103216:	75 c8                	jne    801031e0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103218:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010321b:	89 f0                	mov    %esi,%eax
8010321d:	5b                   	pop    %ebx
8010321e:	5e                   	pop    %esi
8010321f:	5f                   	pop    %edi
80103220:	5d                   	pop    %ebp
80103221:	c3                   	ret    
80103222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103228:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010322b:	31 f6                	xor    %esi,%esi
}
8010322d:	5b                   	pop    %ebx
8010322e:	89 f0                	mov    %esi,%eax
80103230:	5e                   	pop    %esi
80103231:	5f                   	pop    %edi
80103232:	5d                   	pop    %ebp
80103233:	c3                   	ret    
80103234:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010323b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010323f:	90                   	nop

80103240 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	57                   	push   %edi
80103244:	56                   	push   %esi
80103245:	53                   	push   %ebx
80103246:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103249:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103250:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103257:	c1 e0 08             	shl    $0x8,%eax
8010325a:	09 d0                	or     %edx,%eax
8010325c:	c1 e0 04             	shl    $0x4,%eax
8010325f:	75 1b                	jne    8010327c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103261:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103268:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010326f:	c1 e0 08             	shl    $0x8,%eax
80103272:	09 d0                	or     %edx,%eax
80103274:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103277:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010327c:	ba 00 04 00 00       	mov    $0x400,%edx
80103281:	e8 3a ff ff ff       	call   801031c0 <mpsearch1>
80103286:	89 c3                	mov    %eax,%ebx
80103288:	85 c0                	test   %eax,%eax
8010328a:	0f 84 40 01 00 00    	je     801033d0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103290:	8b 73 04             	mov    0x4(%ebx),%esi
80103293:	85 f6                	test   %esi,%esi
80103295:	0f 84 25 01 00 00    	je     801033c0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010329b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010329e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801032a4:	6a 04                	push   $0x4
801032a6:	68 7d 7f 10 80       	push   $0x80107f7d
801032ab:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032af:	e8 6c 15 00 00       	call   80104820 <memcmp>
801032b4:	83 c4 10             	add    $0x10,%esp
801032b7:	85 c0                	test   %eax,%eax
801032b9:	0f 85 01 01 00 00    	jne    801033c0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801032bf:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801032c6:	3c 01                	cmp    $0x1,%al
801032c8:	74 08                	je     801032d2 <mpinit+0x92>
801032ca:	3c 04                	cmp    $0x4,%al
801032cc:	0f 85 ee 00 00 00    	jne    801033c0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032d2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032d9:	66 85 d2             	test   %dx,%dx
801032dc:	74 22                	je     80103300 <mpinit+0xc0>
801032de:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032e1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032e3:	31 d2                	xor    %edx,%edx
801032e5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032e8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032ef:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032f2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032f4:	39 c7                	cmp    %eax,%edi
801032f6:	75 f0                	jne    801032e8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032f8:	84 d2                	test   %dl,%dl
801032fa:	0f 85 c0 00 00 00    	jne    801033c0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103300:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103306:	a3 80 26 19 80       	mov    %eax,0x80192680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010330b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103312:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103318:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010331d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103320:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103323:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103327:	90                   	nop
80103328:	39 d0                	cmp    %edx,%eax
8010332a:	73 15                	jae    80103341 <mpinit+0x101>
    switch(*p){
8010332c:	0f b6 08             	movzbl (%eax),%ecx
8010332f:	80 f9 02             	cmp    $0x2,%cl
80103332:	74 4c                	je     80103380 <mpinit+0x140>
80103334:	77 3a                	ja     80103370 <mpinit+0x130>
80103336:	84 c9                	test   %cl,%cl
80103338:	74 56                	je     80103390 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010333a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010333d:	39 d0                	cmp    %edx,%eax
8010333f:	72 eb                	jb     8010332c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103341:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103344:	85 f6                	test   %esi,%esi
80103346:	0f 84 d9 00 00 00    	je     80103425 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010334c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103350:	74 15                	je     80103367 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103352:	b8 70 00 00 00       	mov    $0x70,%eax
80103357:	ba 22 00 00 00       	mov    $0x22,%edx
8010335c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010335d:	ba 23 00 00 00       	mov    $0x23,%edx
80103362:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103363:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103366:	ee                   	out    %al,(%dx)
  }
}
80103367:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010336a:	5b                   	pop    %ebx
8010336b:	5e                   	pop    %esi
8010336c:	5f                   	pop    %edi
8010336d:	5d                   	pop    %ebp
8010336e:	c3                   	ret    
8010336f:	90                   	nop
    switch(*p){
80103370:	83 e9 03             	sub    $0x3,%ecx
80103373:	80 f9 01             	cmp    $0x1,%cl
80103376:	76 c2                	jbe    8010333a <mpinit+0xfa>
80103378:	31 f6                	xor    %esi,%esi
8010337a:	eb ac                	jmp    80103328 <mpinit+0xe8>
8010337c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103380:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103384:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103387:	88 0d 80 27 19 80    	mov    %cl,0x80192780
      continue;
8010338d:	eb 99                	jmp    80103328 <mpinit+0xe8>
8010338f:	90                   	nop
      if(ncpu < NCPU) {
80103390:	8b 0d 84 27 19 80    	mov    0x80192784,%ecx
80103396:	83 f9 07             	cmp    $0x7,%ecx
80103399:	7f 19                	jg     801033b4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010339b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801033a1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033a5:	83 c1 01             	add    $0x1,%ecx
801033a8:	89 0d 84 27 19 80    	mov    %ecx,0x80192784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033ae:	88 9f a0 27 19 80    	mov    %bl,-0x7fe6d860(%edi)
      p += sizeof(struct mpproc);
801033b4:	83 c0 14             	add    $0x14,%eax
      continue;
801033b7:	e9 6c ff ff ff       	jmp    80103328 <mpinit+0xe8>
801033bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033c0:	83 ec 0c             	sub    $0xc,%esp
801033c3:	68 82 7f 10 80       	push   $0x80107f82
801033c8:	e8 b3 cf ff ff       	call   80100380 <panic>
801033cd:	8d 76 00             	lea    0x0(%esi),%esi
{
801033d0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033d5:	eb 13                	jmp    801033ea <mpinit+0x1aa>
801033d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033de:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033e0:	89 f3                	mov    %esi,%ebx
801033e2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033e8:	74 d6                	je     801033c0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ea:	83 ec 04             	sub    $0x4,%esp
801033ed:	8d 73 10             	lea    0x10(%ebx),%esi
801033f0:	6a 04                	push   $0x4
801033f2:	68 78 7f 10 80       	push   $0x80107f78
801033f7:	53                   	push   %ebx
801033f8:	e8 23 14 00 00       	call   80104820 <memcmp>
801033fd:	83 c4 10             	add    $0x10,%esp
80103400:	85 c0                	test   %eax,%eax
80103402:	75 dc                	jne    801033e0 <mpinit+0x1a0>
80103404:	89 da                	mov    %ebx,%edx
80103406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010340d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103410:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103413:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103416:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103418:	39 d6                	cmp    %edx,%esi
8010341a:	75 f4                	jne    80103410 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010341c:	84 c0                	test   %al,%al
8010341e:	75 c0                	jne    801033e0 <mpinit+0x1a0>
80103420:	e9 6b fe ff ff       	jmp    80103290 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103425:	83 ec 0c             	sub    $0xc,%esp
80103428:	68 9c 7f 10 80       	push   $0x80107f9c
8010342d:	e8 4e cf ff ff       	call   80100380 <panic>
80103432:	66 90                	xchg   %ax,%ax
80103434:	66 90                	xchg   %ax,%ax
80103436:	66 90                	xchg   %ax,%ax
80103438:	66 90                	xchg   %ax,%ax
8010343a:	66 90                	xchg   %ax,%ax
8010343c:	66 90                	xchg   %ax,%ax
8010343e:	66 90                	xchg   %ax,%ax

80103440 <picinit>:
80103440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103445:	ba 21 00 00 00       	mov    $0x21,%edx
8010344a:	ee                   	out    %al,(%dx)
8010344b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103450:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103451:	c3                   	ret    
80103452:	66 90                	xchg   %ax,%ax
80103454:	66 90                	xchg   %ax,%ax
80103456:	66 90                	xchg   %ax,%ax
80103458:	66 90                	xchg   %ax,%ax
8010345a:	66 90                	xchg   %ax,%ax
8010345c:	66 90                	xchg   %ax,%ax
8010345e:	66 90                	xchg   %ax,%ax

80103460 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	57                   	push   %edi
80103464:	56                   	push   %esi
80103465:	53                   	push   %ebx
80103466:	83 ec 0c             	sub    $0xc,%esp
80103469:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010346c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010346f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103475:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010347b:	e8 c0 d9 ff ff       	call   80100e40 <filealloc>
80103480:	89 03                	mov    %eax,(%ebx)
80103482:	85 c0                	test   %eax,%eax
80103484:	0f 84 a8 00 00 00    	je     80103532 <pipealloc+0xd2>
8010348a:	e8 b1 d9 ff ff       	call   80100e40 <filealloc>
8010348f:	89 06                	mov    %eax,(%esi)
80103491:	85 c0                	test   %eax,%eax
80103493:	0f 84 87 00 00 00    	je     80103520 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103499:	e8 12 f2 ff ff       	call   801026b0 <kalloc>
8010349e:	89 c7                	mov    %eax,%edi
801034a0:	85 c0                	test   %eax,%eax
801034a2:	0f 84 b0 00 00 00    	je     80103558 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
801034a8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034af:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034b2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801034b5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034bc:	00 00 00 
  p->nwrite = 0;
801034bf:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034c6:	00 00 00 
  p->nread = 0;
801034c9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034d0:	00 00 00 
  initlock(&p->lock, "pipe");
801034d3:	68 bb 7f 10 80       	push   $0x80107fbb
801034d8:	50                   	push   %eax
801034d9:	e8 62 10 00 00       	call   80104540 <initlock>
  (*f0)->type = FD_PIPE;
801034de:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034e0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034e3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034e9:	8b 03                	mov    (%ebx),%eax
801034eb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034ef:	8b 03                	mov    (%ebx),%eax
801034f1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034f5:	8b 03                	mov    (%ebx),%eax
801034f7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034fa:	8b 06                	mov    (%esi),%eax
801034fc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103502:	8b 06                	mov    (%esi),%eax
80103504:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103508:	8b 06                	mov    (%esi),%eax
8010350a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010350e:	8b 06                	mov    (%esi),%eax
80103510:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103513:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103516:	31 c0                	xor    %eax,%eax
}
80103518:	5b                   	pop    %ebx
80103519:	5e                   	pop    %esi
8010351a:	5f                   	pop    %edi
8010351b:	5d                   	pop    %ebp
8010351c:	c3                   	ret    
8010351d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103520:	8b 03                	mov    (%ebx),%eax
80103522:	85 c0                	test   %eax,%eax
80103524:	74 1e                	je     80103544 <pipealloc+0xe4>
    fileclose(*f0);
80103526:	83 ec 0c             	sub    $0xc,%esp
80103529:	50                   	push   %eax
8010352a:	e8 d1 d9 ff ff       	call   80100f00 <fileclose>
8010352f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103532:	8b 06                	mov    (%esi),%eax
80103534:	85 c0                	test   %eax,%eax
80103536:	74 0c                	je     80103544 <pipealloc+0xe4>
    fileclose(*f1);
80103538:	83 ec 0c             	sub    $0xc,%esp
8010353b:	50                   	push   %eax
8010353c:	e8 bf d9 ff ff       	call   80100f00 <fileclose>
80103541:	83 c4 10             	add    $0x10,%esp
}
80103544:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103547:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010354c:	5b                   	pop    %ebx
8010354d:	5e                   	pop    %esi
8010354e:	5f                   	pop    %edi
8010354f:	5d                   	pop    %ebp
80103550:	c3                   	ret    
80103551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103558:	8b 03                	mov    (%ebx),%eax
8010355a:	85 c0                	test   %eax,%eax
8010355c:	75 c8                	jne    80103526 <pipealloc+0xc6>
8010355e:	eb d2                	jmp    80103532 <pipealloc+0xd2>

80103560 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103560:	55                   	push   %ebp
80103561:	89 e5                	mov    %esp,%ebp
80103563:	56                   	push   %esi
80103564:	53                   	push   %ebx
80103565:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103568:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010356b:	83 ec 0c             	sub    $0xc,%esp
8010356e:	53                   	push   %ebx
8010356f:	e8 9c 11 00 00       	call   80104710 <acquire>
  if(writable){
80103574:	83 c4 10             	add    $0x10,%esp
80103577:	85 f6                	test   %esi,%esi
80103579:	74 65                	je     801035e0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010357b:	83 ec 0c             	sub    $0xc,%esp
8010357e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103584:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010358b:	00 00 00 
    wakeup(&p->nread);
8010358e:	50                   	push   %eax
8010358f:	e8 dc 0c 00 00       	call   80104270 <wakeup>
80103594:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103597:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010359d:	85 d2                	test   %edx,%edx
8010359f:	75 0a                	jne    801035ab <pipeclose+0x4b>
801035a1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035a7:	85 c0                	test   %eax,%eax
801035a9:	74 15                	je     801035c0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035b1:	5b                   	pop    %ebx
801035b2:	5e                   	pop    %esi
801035b3:	5d                   	pop    %ebp
    release(&p->lock);
801035b4:	e9 f7 10 00 00       	jmp    801046b0 <release>
801035b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035c0:	83 ec 0c             	sub    $0xc,%esp
801035c3:	53                   	push   %ebx
801035c4:	e8 e7 10 00 00       	call   801046b0 <release>
    kfree((char*)p);
801035c9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035cc:	83 c4 10             	add    $0x10,%esp
}
801035cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035d2:	5b                   	pop    %ebx
801035d3:	5e                   	pop    %esi
801035d4:	5d                   	pop    %ebp
    kfree((char*)p);
801035d5:	e9 f6 ee ff ff       	jmp    801024d0 <kfree>
801035da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035e0:	83 ec 0c             	sub    $0xc,%esp
801035e3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035e9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035f0:	00 00 00 
    wakeup(&p->nwrite);
801035f3:	50                   	push   %eax
801035f4:	e8 77 0c 00 00       	call   80104270 <wakeup>
801035f9:	83 c4 10             	add    $0x10,%esp
801035fc:	eb 99                	jmp    80103597 <pipeclose+0x37>
801035fe:	66 90                	xchg   %ax,%ax

80103600 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	57                   	push   %edi
80103604:	56                   	push   %esi
80103605:	53                   	push   %ebx
80103606:	83 ec 28             	sub    $0x28,%esp
80103609:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010360c:	53                   	push   %ebx
8010360d:	e8 fe 10 00 00       	call   80104710 <acquire>
  for(i = 0; i < n; i++){
80103612:	8b 45 10             	mov    0x10(%ebp),%eax
80103615:	83 c4 10             	add    $0x10,%esp
80103618:	85 c0                	test   %eax,%eax
8010361a:	0f 8e c0 00 00 00    	jle    801036e0 <pipewrite+0xe0>
80103620:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103623:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103629:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010362f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103632:	03 45 10             	add    0x10(%ebp),%eax
80103635:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103638:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010363e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103644:	89 ca                	mov    %ecx,%edx
80103646:	05 00 02 00 00       	add    $0x200,%eax
8010364b:	39 c1                	cmp    %eax,%ecx
8010364d:	74 3f                	je     8010368e <pipewrite+0x8e>
8010364f:	eb 67                	jmp    801036b8 <pipewrite+0xb8>
80103651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103658:	e8 63 03 00 00       	call   801039c0 <myproc>
8010365d:	8b 48 24             	mov    0x24(%eax),%ecx
80103660:	85 c9                	test   %ecx,%ecx
80103662:	75 34                	jne    80103698 <pipewrite+0x98>
      wakeup(&p->nread);
80103664:	83 ec 0c             	sub    $0xc,%esp
80103667:	57                   	push   %edi
80103668:	e8 03 0c 00 00       	call   80104270 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010366d:	58                   	pop    %eax
8010366e:	5a                   	pop    %edx
8010366f:	53                   	push   %ebx
80103670:	56                   	push   %esi
80103671:	e8 3a 0b 00 00       	call   801041b0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103676:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010367c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103682:	83 c4 10             	add    $0x10,%esp
80103685:	05 00 02 00 00       	add    $0x200,%eax
8010368a:	39 c2                	cmp    %eax,%edx
8010368c:	75 2a                	jne    801036b8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010368e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103694:	85 c0                	test   %eax,%eax
80103696:	75 c0                	jne    80103658 <pipewrite+0x58>
        release(&p->lock);
80103698:	83 ec 0c             	sub    $0xc,%esp
8010369b:	53                   	push   %ebx
8010369c:	e8 0f 10 00 00       	call   801046b0 <release>
        return -1;
801036a1:	83 c4 10             	add    $0x10,%esp
801036a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036ac:	5b                   	pop    %ebx
801036ad:	5e                   	pop    %esi
801036ae:	5f                   	pop    %edi
801036af:	5d                   	pop    %ebp
801036b0:	c3                   	ret    
801036b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036b8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036bb:	8d 4a 01             	lea    0x1(%edx),%ecx
801036be:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036c4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036ca:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801036cd:	83 c6 01             	add    $0x1,%esi
801036d0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036d3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036d7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036da:	0f 85 58 ff ff ff    	jne    80103638 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036e0:	83 ec 0c             	sub    $0xc,%esp
801036e3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036e9:	50                   	push   %eax
801036ea:	e8 81 0b 00 00       	call   80104270 <wakeup>
  release(&p->lock);
801036ef:	89 1c 24             	mov    %ebx,(%esp)
801036f2:	e8 b9 0f 00 00       	call   801046b0 <release>
  return n;
801036f7:	8b 45 10             	mov    0x10(%ebp),%eax
801036fa:	83 c4 10             	add    $0x10,%esp
801036fd:	eb aa                	jmp    801036a9 <pipewrite+0xa9>
801036ff:	90                   	nop

80103700 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	57                   	push   %edi
80103704:	56                   	push   %esi
80103705:	53                   	push   %ebx
80103706:	83 ec 18             	sub    $0x18,%esp
80103709:	8b 75 08             	mov    0x8(%ebp),%esi
8010370c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010370f:	56                   	push   %esi
80103710:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103716:	e8 f5 0f 00 00       	call   80104710 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010371b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103721:	83 c4 10             	add    $0x10,%esp
80103724:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010372a:	74 2f                	je     8010375b <piperead+0x5b>
8010372c:	eb 37                	jmp    80103765 <piperead+0x65>
8010372e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103730:	e8 8b 02 00 00       	call   801039c0 <myproc>
80103735:	8b 48 24             	mov    0x24(%eax),%ecx
80103738:	85 c9                	test   %ecx,%ecx
8010373a:	0f 85 80 00 00 00    	jne    801037c0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103740:	83 ec 08             	sub    $0x8,%esp
80103743:	56                   	push   %esi
80103744:	53                   	push   %ebx
80103745:	e8 66 0a 00 00       	call   801041b0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010374a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103750:	83 c4 10             	add    $0x10,%esp
80103753:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103759:	75 0a                	jne    80103765 <piperead+0x65>
8010375b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103761:	85 c0                	test   %eax,%eax
80103763:	75 cb                	jne    80103730 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103765:	8b 55 10             	mov    0x10(%ebp),%edx
80103768:	31 db                	xor    %ebx,%ebx
8010376a:	85 d2                	test   %edx,%edx
8010376c:	7f 20                	jg     8010378e <piperead+0x8e>
8010376e:	eb 2c                	jmp    8010379c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103770:	8d 48 01             	lea    0x1(%eax),%ecx
80103773:	25 ff 01 00 00       	and    $0x1ff,%eax
80103778:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010377e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103783:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103786:	83 c3 01             	add    $0x1,%ebx
80103789:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010378c:	74 0e                	je     8010379c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010378e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103794:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010379a:	75 d4                	jne    80103770 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010379c:	83 ec 0c             	sub    $0xc,%esp
8010379f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037a5:	50                   	push   %eax
801037a6:	e8 c5 0a 00 00       	call   80104270 <wakeup>
  release(&p->lock);
801037ab:	89 34 24             	mov    %esi,(%esp)
801037ae:	e8 fd 0e 00 00       	call   801046b0 <release>
  return i;
801037b3:	83 c4 10             	add    $0x10,%esp
}
801037b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037b9:	89 d8                	mov    %ebx,%eax
801037bb:	5b                   	pop    %ebx
801037bc:	5e                   	pop    %esi
801037bd:	5f                   	pop    %edi
801037be:	5d                   	pop    %ebp
801037bf:	c3                   	ret    
      release(&p->lock);
801037c0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037c3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037c8:	56                   	push   %esi
801037c9:	e8 e2 0e 00 00       	call   801046b0 <release>
      return -1;
801037ce:	83 c4 10             	add    $0x10,%esp
}
801037d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037d4:	89 d8                	mov    %ebx,%eax
801037d6:	5b                   	pop    %ebx
801037d7:	5e                   	pop    %esi
801037d8:	5f                   	pop    %edi
801037d9:	5d                   	pop    %ebp
801037da:	c3                   	ret    
801037db:	66 90                	xchg   %ax,%ax
801037dd:	66 90                	xchg   %ax,%ax
801037df:	90                   	nop

801037e0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037e4:	bb 54 2d 19 80       	mov    $0x80192d54,%ebx
{
801037e9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037ec:	68 20 2d 19 80       	push   $0x80192d20
801037f1:	e8 1a 0f 00 00       	call   80104710 <acquire>
801037f6:	83 c4 10             	add    $0x10,%esp
801037f9:	eb 17                	jmp    80103812 <allocproc+0x32>
801037fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037ff:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103800:	81 c3 c0 01 00 00    	add    $0x1c0,%ebx
80103806:	81 fb 54 9d 19 80    	cmp    $0x80199d54,%ebx
8010380c:	0f 84 8e 00 00 00    	je     801038a0 <allocproc+0xc0>
    if(p->state == UNUSED)
80103812:	8b 43 0c             	mov    0xc(%ebx),%eax
80103815:	85 c0                	test   %eax,%eax
80103817:	75 e7                	jne    80103800 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103819:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
8010381e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103821:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103828:	89 43 10             	mov    %eax,0x10(%ebx)
8010382b:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
8010382e:	68 20 2d 19 80       	push   $0x80192d20
  p->pid = nextpid++;
80103833:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103839:	e8 72 0e 00 00       	call   801046b0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010383e:	e8 6d ee ff ff       	call   801026b0 <kalloc>
80103843:	83 c4 10             	add    $0x10,%esp
80103846:	89 43 08             	mov    %eax,0x8(%ebx)
80103849:	85 c0                	test   %eax,%eax
8010384b:	74 6c                	je     801038b9 <allocproc+0xd9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010384d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103853:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103856:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010385b:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010385e:	c7 40 14 3f 5b 10 80 	movl   $0x80105b3f,0x14(%eax)
  p->context = (struct context*)sp;
80103865:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103868:	6a 14                	push   $0x14
8010386a:	6a 00                	push   $0x0
8010386c:	50                   	push   %eax
8010386d:	e8 5e 0f 00 00       	call   801047d0 <memset>
  p->context->eip = (uint)forkret;
80103872:	8b 43 1c             	mov    0x1c(%ebx),%eax

  memset(&p->mappings, 0, sizeof(p->mappings)); // OUR MODS
80103875:	83 c4 0c             	add    $0xc,%esp
  p->context->eip = (uint)forkret;
80103878:	c7 40 10 d0 38 10 80 	movl   $0x801038d0,0x10(%eax)
  memset(&p->mappings, 0, sizeof(p->mappings)); // OUR MODS
8010387f:	8d 43 7c             	lea    0x7c(%ebx),%eax
80103882:	68 44 01 00 00       	push   $0x144
80103887:	6a 00                	push   $0x0
80103889:	50                   	push   %eax
8010388a:	e8 41 0f 00 00       	call   801047d0 <memset>

  return p;
}
8010388f:	89 d8                	mov    %ebx,%eax
  return p;
80103891:	83 c4 10             	add    $0x10,%esp
}
80103894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103897:	c9                   	leave  
80103898:	c3                   	ret    
80103899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801038a0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038a3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038a5:	68 20 2d 19 80       	push   $0x80192d20
801038aa:	e8 01 0e 00 00       	call   801046b0 <release>
}
801038af:	89 d8                	mov    %ebx,%eax
  return 0;
801038b1:	83 c4 10             	add    $0x10,%esp
}
801038b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038b7:	c9                   	leave  
801038b8:	c3                   	ret    
    p->state = UNUSED;
801038b9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038c0:	31 db                	xor    %ebx,%ebx
}
801038c2:	89 d8                	mov    %ebx,%eax
801038c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038c7:	c9                   	leave  
801038c8:	c3                   	ret    
801038c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038d0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038d6:	68 20 2d 19 80       	push   $0x80192d20
801038db:	e8 d0 0d 00 00       	call   801046b0 <release>

  if (first) {
801038e0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038e5:	83 c4 10             	add    $0x10,%esp
801038e8:	85 c0                	test   %eax,%eax
801038ea:	75 04                	jne    801038f0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038ec:	c9                   	leave  
801038ed:	c3                   	ret    
801038ee:	66 90                	xchg   %ax,%ax
    first = 0;
801038f0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038f7:	00 00 00 
    iinit(ROOTDEV);
801038fa:	83 ec 0c             	sub    $0xc,%esp
801038fd:	6a 01                	push   $0x1
801038ff:	e8 6c dc ff ff       	call   80101570 <iinit>
    initlog(ROOTDEV);
80103904:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010390b:	e8 e0 f3 ff ff       	call   80102cf0 <initlog>
}
80103910:	83 c4 10             	add    $0x10,%esp
80103913:	c9                   	leave  
80103914:	c3                   	ret    
80103915:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010391c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103920 <pinit>:
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103926:	68 c0 7f 10 80       	push   $0x80107fc0
8010392b:	68 20 2d 19 80       	push   $0x80192d20
80103930:	e8 0b 0c 00 00       	call   80104540 <initlock>
}
80103935:	83 c4 10             	add    $0x10,%esp
80103938:	c9                   	leave  
80103939:	c3                   	ret    
8010393a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103940 <mycpu>:
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	56                   	push   %esi
80103944:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103945:	9c                   	pushf  
80103946:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103947:	f6 c4 02             	test   $0x2,%ah
8010394a:	75 46                	jne    80103992 <mycpu+0x52>
  apicid = lapicid();
8010394c:	e8 cf ef ff ff       	call   80102920 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103951:	8b 35 84 27 19 80    	mov    0x80192784,%esi
80103957:	85 f6                	test   %esi,%esi
80103959:	7e 2a                	jle    80103985 <mycpu+0x45>
8010395b:	31 d2                	xor    %edx,%edx
8010395d:	eb 08                	jmp    80103967 <mycpu+0x27>
8010395f:	90                   	nop
80103960:	83 c2 01             	add    $0x1,%edx
80103963:	39 f2                	cmp    %esi,%edx
80103965:	74 1e                	je     80103985 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103967:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010396d:	0f b6 99 a0 27 19 80 	movzbl -0x7fe6d860(%ecx),%ebx
80103974:	39 c3                	cmp    %eax,%ebx
80103976:	75 e8                	jne    80103960 <mycpu+0x20>
}
80103978:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010397b:	8d 81 a0 27 19 80    	lea    -0x7fe6d860(%ecx),%eax
}
80103981:	5b                   	pop    %ebx
80103982:	5e                   	pop    %esi
80103983:	5d                   	pop    %ebp
80103984:	c3                   	ret    
  panic("unknown apicid\n");
80103985:	83 ec 0c             	sub    $0xc,%esp
80103988:	68 c7 7f 10 80       	push   $0x80107fc7
8010398d:	e8 ee c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103992:	83 ec 0c             	sub    $0xc,%esp
80103995:	68 a4 80 10 80       	push   $0x801080a4
8010399a:	e8 e1 c9 ff ff       	call   80100380 <panic>
8010399f:	90                   	nop

801039a0 <cpuid>:
cpuid() {
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039a6:	e8 95 ff ff ff       	call   80103940 <mycpu>
}
801039ab:	c9                   	leave  
  return mycpu()-cpus;
801039ac:	2d a0 27 19 80       	sub    $0x801927a0,%eax
801039b1:	c1 f8 04             	sar    $0x4,%eax
801039b4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039ba:	c3                   	ret    
801039bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039bf:	90                   	nop

801039c0 <myproc>:
myproc(void) {
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	53                   	push   %ebx
801039c4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039c7:	e8 f4 0b 00 00       	call   801045c0 <pushcli>
  c = mycpu();
801039cc:	e8 6f ff ff ff       	call   80103940 <mycpu>
  p = c->proc;
801039d1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039d7:	e8 34 0c 00 00       	call   80104610 <popcli>
}
801039dc:	89 d8                	mov    %ebx,%eax
801039de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039e1:	c9                   	leave  
801039e2:	c3                   	ret    
801039e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039f0 <userinit>:
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	53                   	push   %ebx
801039f4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039f7:	e8 e4 fd ff ff       	call   801037e0 <allocproc>
801039fc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039fe:	a3 54 9d 19 80       	mov    %eax,0x80199d54
  if((p->pgdir = setupkvm()) == 0)
80103a03:	e8 e8 39 00 00       	call   801073f0 <setupkvm>
80103a08:	89 43 04             	mov    %eax,0x4(%ebx)
80103a0b:	85 c0                	test   %eax,%eax
80103a0d:	0f 84 bd 00 00 00    	je     80103ad0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a13:	83 ec 04             	sub    $0x4,%esp
80103a16:	68 2c 00 00 00       	push   $0x2c
80103a1b:	68 60 b4 10 80       	push   $0x8010b460
80103a20:	50                   	push   %eax
80103a21:	e8 7a 36 00 00       	call   801070a0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a26:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a29:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a2f:	6a 4c                	push   $0x4c
80103a31:	6a 00                	push   $0x0
80103a33:	ff 73 18             	push   0x18(%ebx)
80103a36:	e8 95 0d 00 00       	call   801047d0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a3b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a3e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a43:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a46:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a4b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a4f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a52:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a56:	8b 43 18             	mov    0x18(%ebx),%eax
80103a59:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a5d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a61:	8b 43 18             	mov    0x18(%ebx),%eax
80103a64:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a68:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a6c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a6f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a76:	8b 43 18             	mov    0x18(%ebx),%eax
80103a79:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a80:	8b 43 18             	mov    0x18(%ebx),%eax
80103a83:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a8a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a8d:	6a 10                	push   $0x10
80103a8f:	68 f0 7f 10 80       	push   $0x80107ff0
80103a94:	50                   	push   %eax
80103a95:	e8 f6 0e 00 00       	call   80104990 <safestrcpy>
  p->cwd = namei("/");
80103a9a:	c7 04 24 f9 7f 10 80 	movl   $0x80107ff9,(%esp)
80103aa1:	e8 0a e6 ff ff       	call   801020b0 <namei>
80103aa6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103aa9:	c7 04 24 20 2d 19 80 	movl   $0x80192d20,(%esp)
80103ab0:	e8 5b 0c 00 00       	call   80104710 <acquire>
  p->state = RUNNABLE;
80103ab5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103abc:	c7 04 24 20 2d 19 80 	movl   $0x80192d20,(%esp)
80103ac3:	e8 e8 0b 00 00       	call   801046b0 <release>
}
80103ac8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103acb:	83 c4 10             	add    $0x10,%esp
80103ace:	c9                   	leave  
80103acf:	c3                   	ret    
    panic("userinit: out of memory?");
80103ad0:	83 ec 0c             	sub    $0xc,%esp
80103ad3:	68 d7 7f 10 80       	push   $0x80107fd7
80103ad8:	e8 a3 c8 ff ff       	call   80100380 <panic>
80103add:	8d 76 00             	lea    0x0(%esi),%esi

80103ae0 <growproc>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	56                   	push   %esi
80103ae4:	53                   	push   %ebx
80103ae5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ae8:	e8 d3 0a 00 00       	call   801045c0 <pushcli>
  c = mycpu();
80103aed:	e8 4e fe ff ff       	call   80103940 <mycpu>
  p = c->proc;
80103af2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103af8:	e8 13 0b 00 00       	call   80104610 <popcli>
  sz = curproc->sz;
80103afd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103aff:	85 f6                	test   %esi,%esi
80103b01:	7f 1d                	jg     80103b20 <growproc+0x40>
  } else if(n < 0){
80103b03:	75 3b                	jne    80103b40 <growproc+0x60>
  switchuvm(curproc);
80103b05:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b08:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b0a:	53                   	push   %ebx
80103b0b:	e8 80 34 00 00       	call   80106f90 <switchuvm>
  return 0;
80103b10:	83 c4 10             	add    $0x10,%esp
80103b13:	31 c0                	xor    %eax,%eax
}
80103b15:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b18:	5b                   	pop    %ebx
80103b19:	5e                   	pop    %esi
80103b1a:	5d                   	pop    %ebp
80103b1b:	c3                   	ret    
80103b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b20:	83 ec 04             	sub    $0x4,%esp
80103b23:	01 c6                	add    %eax,%esi
80103b25:	56                   	push   %esi
80103b26:	50                   	push   %eax
80103b27:	ff 73 04             	push   0x4(%ebx)
80103b2a:	e8 e1 36 00 00       	call   80107210 <allocuvm>
80103b2f:	83 c4 10             	add    $0x10,%esp
80103b32:	85 c0                	test   %eax,%eax
80103b34:	75 cf                	jne    80103b05 <growproc+0x25>
      return -1;
80103b36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b3b:	eb d8                	jmp    80103b15 <growproc+0x35>
80103b3d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b40:	83 ec 04             	sub    $0x4,%esp
80103b43:	01 c6                	add    %eax,%esi
80103b45:	56                   	push   %esi
80103b46:	50                   	push   %eax
80103b47:	ff 73 04             	push   0x4(%ebx)
80103b4a:	e8 f1 37 00 00       	call   80107340 <deallocuvm>
80103b4f:	83 c4 10             	add    $0x10,%esp
80103b52:	85 c0                	test   %eax,%eax
80103b54:	75 af                	jne    80103b05 <growproc+0x25>
80103b56:	eb de                	jmp    80103b36 <growproc+0x56>
80103b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b5f:	90                   	nop

80103b60 <fork>:
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	57                   	push   %edi
80103b64:	56                   	push   %esi
80103b65:	53                   	push   %ebx
80103b66:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b69:	e8 52 0a 00 00       	call   801045c0 <pushcli>
  c = mycpu();
80103b6e:	e8 cd fd ff ff       	call   80103940 <mycpu>
  p = c->proc;
80103b73:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
80103b79:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  popcli();
80103b7c:	e8 8f 0a 00 00       	call   80104610 <popcli>
  if((np = allocproc()) == 0){
80103b81:	e8 5a fc ff ff       	call   801037e0 <allocproc>
80103b86:	85 c0                	test   %eax,%eax
80103b88:	0f 84 c1 01 00 00    	je     80103d4f <fork+0x1ef>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b8e:	83 ec 08             	sub    $0x8,%esp
80103b91:	ff 37                	push   (%edi)
80103b93:	89 c3                	mov    %eax,%ebx
80103b95:	ff 77 04             	push   0x4(%edi)
80103b98:	e8 43 39 00 00       	call   801074e0 <copyuvm>
80103b9d:	83 c4 10             	add    $0x10,%esp
80103ba0:	89 43 04             	mov    %eax,0x4(%ebx)
80103ba3:	85 c0                	test   %eax,%eax
80103ba5:	0f 84 ad 01 00 00    	je     80103d58 <fork+0x1f8>
  np->sz = curproc->sz;
80103bab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  *np->tf = *curproc->tf;
80103bae:	8b 7b 18             	mov    0x18(%ebx),%edi
80103bb1:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103bb6:	8b 02                	mov    (%edx),%eax
  np->parent = curproc;
80103bb8:	89 53 14             	mov    %edx,0x14(%ebx)
  np->sz = curproc->sz;
80103bbb:	89 03                	mov    %eax,(%ebx)
  *np->tf = *curproc->tf;
80103bbd:	8b 72 18             	mov    0x18(%edx),%esi
80103bc0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103bc2:	31 f6                	xor    %esi,%esi
80103bc4:	89 d7                	mov    %edx,%edi
  np->tf->eax = 0;
80103bc6:	8b 43 18             	mov    0x18(%ebx),%eax
80103bc9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103bd0:	8b 44 b7 28          	mov    0x28(%edi,%esi,4),%eax
80103bd4:	85 c0                	test   %eax,%eax
80103bd6:	74 10                	je     80103be8 <fork+0x88>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103bd8:	83 ec 0c             	sub    $0xc,%esp
80103bdb:	50                   	push   %eax
80103bdc:	e8 cf d2 ff ff       	call   80100eb0 <filedup>
80103be1:	83 c4 10             	add    $0x10,%esp
80103be4:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103be8:	83 c6 01             	add    $0x1,%esi
80103beb:	83 fe 10             	cmp    $0x10,%esi
80103bee:	75 e0                	jne    80103bd0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103bf0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103bf3:	83 ec 0c             	sub    $0xc,%esp
80103bf6:	ff 77 68             	push   0x68(%edi)
80103bf9:	e8 62 db ff ff       	call   80101760 <idup>
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bfe:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c01:	89 43 68             	mov    %eax,0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c04:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c07:	6a 10                	push   $0x10
80103c09:	50                   	push   %eax
80103c0a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c0d:	50                   	push   %eax
80103c0e:	e8 7d 0d 00 00       	call   80104990 <safestrcpy>
  pid = np->pid;
80103c13:	8b 43 10             	mov    0x10(%ebx),%eax
  acquire(&ptable.lock);
80103c16:	c7 04 24 20 2d 19 80 	movl   $0x80192d20,(%esp)
  pid = np->pid;
80103c1d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  acquire(&ptable.lock);
80103c20:	e8 eb 0a 00 00       	call   80104710 <acquire>
  np->state = RUNNABLE;
80103c25:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103c2c:	c7 04 24 20 2d 19 80 	movl   $0x80192d20,(%esp)
80103c33:	e8 78 0a 00 00       	call   801046b0 <release>
  np_mappings->total_mmaps = curproc_mappings->total_mmaps;
80103c38:	8b 47 7c             	mov    0x7c(%edi),%eax
80103c3b:	8d 93 80 00 00 00    	lea    0x80(%ebx),%edx
80103c41:	83 c4 10             	add    $0x10,%esp
80103c44:	89 43 7c             	mov    %eax,0x7c(%ebx)
  for(int i = 0; i < MAX_WMMAP_INFO; i++) {
80103c47:	89 f8                	mov    %edi,%eax
80103c49:	8d bf 80 00 00 00    	lea    0x80(%edi),%edi
80103c4f:	8d 88 c0 00 00 00    	lea    0xc0(%eax),%ecx
80103c55:	89 d0                	mov    %edx,%eax
80103c57:	89 da                	mov    %ebx,%edx
80103c59:	89 c3                	mov    %eax,%ebx
80103c5b:	eb 0d                	jmp    80103c6a <fork+0x10a>
80103c5d:	8d 76 00             	lea    0x0(%esi),%esi
80103c60:	83 c7 04             	add    $0x4,%edi
80103c63:	83 c3 04             	add    $0x4,%ebx
80103c66:	39 cf                	cmp    %ecx,%edi
80103c68:	74 38                	je     80103ca2 <fork+0x142>
    if(curproc_mappings->length[i] > 0) { // mapping found
80103c6a:	8b 77 40             	mov    0x40(%edi),%esi
80103c6d:	85 f6                	test   %esi,%esi
80103c6f:	7e ef                	jle    80103c60 <fork+0x100>
      np_mappings->addr[i] = curproc_mappings->addr[i];
80103c71:	8b 07                	mov    (%edi),%eax
80103c73:	89 03                	mov    %eax,(%ebx)
      np_mappings->length[i] = curproc_mappings->length[i];
80103c75:	8b 47 40             	mov    0x40(%edi),%eax
80103c78:	89 43 40             	mov    %eax,0x40(%ebx)
      np_mappings->n_loaded_pages[i] = curproc_mappings->n_loaded_pages[i];
80103c7b:	8b 87 80 00 00 00    	mov    0x80(%edi),%eax
80103c81:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
      np_mappings->flags[i] = curproc_mappings->flags[i];
80103c87:	8b b7 c0 00 00 00    	mov    0xc0(%edi),%esi
80103c8d:	89 b3 c0 00 00 00    	mov    %esi,0xc0(%ebx)
      if((np_mappings->flags[i] & MAP_ANONYMOUS) == 0) { // file-backed
80103c93:	83 e6 04             	and    $0x4,%esi
80103c96:	74 7c                	je     80103d14 <fork+0x1b4>
  for(int i = 0; i < MAX_WMMAP_INFO; i++) {
80103c98:	83 c7 04             	add    $0x4,%edi
80103c9b:	83 c3 04             	add    $0x4,%ebx
80103c9e:	39 cf                	cmp    %ecx,%edi
80103ca0:	75 c8                	jne    80103c6a <fork+0x10a>
  for(uint addr = KERNBASE - (1 << 29); addr < KERNBASE; addr += PGSIZE) {
80103ca2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103ca5:	89 d3                	mov    %edx,%ebx
80103ca7:	be 00 00 00 60       	mov    $0x60000000,%esi
80103cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pte_t *pte = walkpgdir(curproc->pgdir, (void *)addr, 0);
80103cb0:	83 ec 04             	sub    $0x4,%esp
80103cb3:	6a 00                	push   $0x0
80103cb5:	56                   	push   %esi
80103cb6:	ff 77 04             	push   0x4(%edi)
80103cb9:	e8 42 31 00 00       	call   80106e00 <walkpgdir>
    if(pte == 0 || (*pte & PTE_P) == 0) { // page table doesn't exist or pte doesn't contiain ppn
80103cbe:	83 c4 10             	add    $0x10,%esp
80103cc1:	85 c0                	test   %eax,%eax
80103cc3:	74 29                	je     80103cee <fork+0x18e>
80103cc5:	8b 00                	mov    (%eax),%eax
80103cc7:	a8 01                	test   $0x1,%al
80103cc9:	74 23                	je     80103cee <fork+0x18e>
      int flags = PTE_FLAGS(*pte);
80103ccb:	89 c2                	mov    %eax,%edx
      mappages(np->pgdir, (void *)addr, PGSIZE, pa, flags); // map page
80103ccd:	83 ec 0c             	sub    $0xc,%esp
      uint pa = PTE_ADDR(*pte);
80103cd0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      int flags = PTE_FLAGS(*pte);
80103cd5:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
      mappages(np->pgdir, (void *)addr, PGSIZE, pa, flags); // map page
80103cdb:	52                   	push   %edx
80103cdc:	50                   	push   %eax
80103cdd:	68 00 10 00 00       	push   $0x1000
80103ce2:	56                   	push   %esi
80103ce3:	ff 73 04             	push   0x4(%ebx)
80103ce6:	e8 a5 31 00 00       	call   80106e90 <mappages>
80103ceb:	83 c4 20             	add    $0x20,%esp
  for(uint addr = KERNBASE - (1 << 29); addr < KERNBASE; addr += PGSIZE) {
80103cee:	81 c6 00 10 00 00    	add    $0x1000,%esi
80103cf4:	79 ba                	jns    80103cb0 <fork+0x150>
}
80103cf6:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103cf9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cfc:	5b                   	pop    %ebx
80103cfd:	5e                   	pop    %esi
80103cfe:	5f                   	pop    %edi
80103cff:	5d                   	pop    %ebp
80103d00:	c3                   	ret    
80103d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        for(int j = 0; j < NOFILE; j++) {
80103d08:	83 c6 01             	add    $0x1,%esi
80103d0b:	83 fe 10             	cmp    $0x10,%esi
80103d0e:	0f 84 4c ff ff ff    	je     80103c60 <fork+0x100>
          if(np->ofile[j] == 0) { // empty slot is found
80103d14:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103d18:	85 c0                	test   %eax,%eax
80103d1a:	75 ec                	jne    80103d08 <fork+0x1a8>
            np->ofile[j] = filedup(curproc->ofile[curproc_mappings->fd[i]]);
80103d1c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80103d1f:	8b 87 00 01 00 00    	mov    0x100(%edi),%eax
80103d25:	83 ec 0c             	sub    $0xc,%esp
80103d28:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d2b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80103d2e:	ff 74 81 28          	push   0x28(%ecx,%eax,4)
80103d32:	e8 79 d1 ff ff       	call   80100eb0 <filedup>
80103d37:	8b 55 dc             	mov    -0x24(%ebp),%edx
            break;
80103d3a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80103d3d:	83 c4 10             	add    $0x10,%esp
            np->ofile[j] = filedup(curproc->ofile[curproc_mappings->fd[i]]);
80103d40:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
            np_mappings->fd[i] = j;
80103d44:	89 b3 00 01 00 00    	mov    %esi,0x100(%ebx)
            break;
80103d4a:	e9 11 ff ff ff       	jmp    80103c60 <fork+0x100>
    return -1;
80103d4f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
80103d56:	eb 9e                	jmp    80103cf6 <fork+0x196>
    kfree(np->kstack);
80103d58:	83 ec 0c             	sub    $0xc,%esp
80103d5b:	ff 73 08             	push   0x8(%ebx)
80103d5e:	e8 6d e7 ff ff       	call   801024d0 <kfree>
    np->kstack = 0;
80103d63:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103d6a:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103d6d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d74:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
80103d7b:	e9 76 ff ff ff       	jmp    80103cf6 <fork+0x196>

80103d80 <scheduler>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	57                   	push   %edi
80103d84:	56                   	push   %esi
80103d85:	53                   	push   %ebx
80103d86:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103d89:	e8 b2 fb ff ff       	call   80103940 <mycpu>
  c->proc = 0;
80103d8e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d95:	00 00 00 
  struct cpu *c = mycpu();
80103d98:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d9a:	8d 78 04             	lea    0x4(%eax),%edi
80103d9d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103da0:	fb                   	sti    
    acquire(&ptable.lock);
80103da1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103da4:	bb 54 2d 19 80       	mov    $0x80192d54,%ebx
    acquire(&ptable.lock);
80103da9:	68 20 2d 19 80       	push   $0x80192d20
80103dae:	e8 5d 09 00 00       	call   80104710 <acquire>
80103db3:	83 c4 10             	add    $0x10,%esp
80103db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dbd:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103dc0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103dc4:	75 33                	jne    80103df9 <scheduler+0x79>
      switchuvm(p);
80103dc6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103dc9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103dcf:	53                   	push   %ebx
80103dd0:	e8 bb 31 00 00       	call   80106f90 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103dd5:	58                   	pop    %eax
80103dd6:	5a                   	pop    %edx
80103dd7:	ff 73 1c             	push   0x1c(%ebx)
80103dda:	57                   	push   %edi
      p->state = RUNNING;
80103ddb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103de2:	e8 04 0c 00 00       	call   801049eb <swtch>
      switchkvm();
80103de7:	e8 94 31 00 00       	call   80106f80 <switchkvm>
      c->proc = 0;
80103dec:	83 c4 10             	add    $0x10,%esp
80103def:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103df6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103df9:	81 c3 c0 01 00 00    	add    $0x1c0,%ebx
80103dff:	81 fb 54 9d 19 80    	cmp    $0x80199d54,%ebx
80103e05:	75 b9                	jne    80103dc0 <scheduler+0x40>
    release(&ptable.lock);
80103e07:	83 ec 0c             	sub    $0xc,%esp
80103e0a:	68 20 2d 19 80       	push   $0x80192d20
80103e0f:	e8 9c 08 00 00       	call   801046b0 <release>
    sti();
80103e14:	83 c4 10             	add    $0x10,%esp
80103e17:	eb 87                	jmp    80103da0 <scheduler+0x20>
80103e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e20 <sched>:
{
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	56                   	push   %esi
80103e24:	53                   	push   %ebx
  pushcli();
80103e25:	e8 96 07 00 00       	call   801045c0 <pushcli>
  c = mycpu();
80103e2a:	e8 11 fb ff ff       	call   80103940 <mycpu>
  p = c->proc;
80103e2f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e35:	e8 d6 07 00 00       	call   80104610 <popcli>
  if(!holding(&ptable.lock))
80103e3a:	83 ec 0c             	sub    $0xc,%esp
80103e3d:	68 20 2d 19 80       	push   $0x80192d20
80103e42:	e8 29 08 00 00       	call   80104670 <holding>
80103e47:	83 c4 10             	add    $0x10,%esp
80103e4a:	85 c0                	test   %eax,%eax
80103e4c:	74 4f                	je     80103e9d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103e4e:	e8 ed fa ff ff       	call   80103940 <mycpu>
80103e53:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e5a:	75 68                	jne    80103ec4 <sched+0xa4>
  if(p->state == RUNNING)
80103e5c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103e60:	74 55                	je     80103eb7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e62:	9c                   	pushf  
80103e63:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e64:	f6 c4 02             	test   $0x2,%ah
80103e67:	75 41                	jne    80103eaa <sched+0x8a>
  intena = mycpu()->intena;
80103e69:	e8 d2 fa ff ff       	call   80103940 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103e6e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103e71:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103e77:	e8 c4 fa ff ff       	call   80103940 <mycpu>
80103e7c:	83 ec 08             	sub    $0x8,%esp
80103e7f:	ff 70 04             	push   0x4(%eax)
80103e82:	53                   	push   %ebx
80103e83:	e8 63 0b 00 00       	call   801049eb <swtch>
  mycpu()->intena = intena;
80103e88:	e8 b3 fa ff ff       	call   80103940 <mycpu>
}
80103e8d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e90:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e99:	5b                   	pop    %ebx
80103e9a:	5e                   	pop    %esi
80103e9b:	5d                   	pop    %ebp
80103e9c:	c3                   	ret    
    panic("sched ptable.lock");
80103e9d:	83 ec 0c             	sub    $0xc,%esp
80103ea0:	68 fb 7f 10 80       	push   $0x80107ffb
80103ea5:	e8 d6 c4 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103eaa:	83 ec 0c             	sub    $0xc,%esp
80103ead:	68 27 80 10 80       	push   $0x80108027
80103eb2:	e8 c9 c4 ff ff       	call   80100380 <panic>
    panic("sched running");
80103eb7:	83 ec 0c             	sub    $0xc,%esp
80103eba:	68 19 80 10 80       	push   $0x80108019
80103ebf:	e8 bc c4 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103ec4:	83 ec 0c             	sub    $0xc,%esp
80103ec7:	68 0d 80 10 80       	push   $0x8010800d
80103ecc:	e8 af c4 ff ff       	call   80100380 <panic>
80103ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103edf:	90                   	nop

80103ee0 <exit>:
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	57                   	push   %edi
80103ee4:	56                   	push   %esi
80103ee5:	53                   	push   %ebx
80103ee6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103ee9:	e8 d2 fa ff ff       	call   801039c0 <myproc>
  if(curproc == initproc)
80103eee:	39 05 54 9d 19 80    	cmp    %eax,0x80199d54
80103ef4:	0f 84 27 01 00 00    	je     80104021 <exit+0x141>
80103efa:	89 c3                	mov    %eax,%ebx
80103efc:	8d b0 80 00 00 00    	lea    0x80(%eax),%esi
80103f02:	8d b8 c0 00 00 00    	lea    0xc0(%eax),%edi
80103f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f0f:	90                   	nop
    wunmap(mappings->addr[i]);
80103f10:	83 ec 0c             	sub    $0xc,%esp
80103f13:	ff 36                	push   (%esi)
  for(int i = 0; i < MAX_WMMAP_INFO; i++) {
80103f15:	83 c6 04             	add    $0x4,%esi
    wunmap(mappings->addr[i]);
80103f18:	e8 13 39 00 00       	call   80107830 <wunmap>
  for(int i = 0; i < MAX_WMMAP_INFO; i++) {
80103f1d:	83 c4 10             	add    $0x10,%esp
80103f20:	39 f7                	cmp    %esi,%edi
80103f22:	75 ec                	jne    80103f10 <exit+0x30>
80103f24:	8d 73 28             	lea    0x28(%ebx),%esi
80103f27:	8d 7b 68             	lea    0x68(%ebx),%edi
80103f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103f30:	8b 06                	mov    (%esi),%eax
80103f32:	85 c0                	test   %eax,%eax
80103f34:	74 12                	je     80103f48 <exit+0x68>
      fileclose(curproc->ofile[fd]);
80103f36:	83 ec 0c             	sub    $0xc,%esp
80103f39:	50                   	push   %eax
80103f3a:	e8 c1 cf ff ff       	call   80100f00 <fileclose>
      curproc->ofile[fd] = 0;
80103f3f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103f45:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103f48:	83 c6 04             	add    $0x4,%esi
80103f4b:	39 fe                	cmp    %edi,%esi
80103f4d:	75 e1                	jne    80103f30 <exit+0x50>
  begin_op();
80103f4f:	e8 3c ee ff ff       	call   80102d90 <begin_op>
  iput(curproc->cwd);
80103f54:	83 ec 0c             	sub    $0xc,%esp
80103f57:	ff 73 68             	push   0x68(%ebx)
80103f5a:	e8 61 d9 ff ff       	call   801018c0 <iput>
  end_op();
80103f5f:	e8 9c ee ff ff       	call   80102e00 <end_op>
  curproc->cwd = 0;
80103f64:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103f6b:	c7 04 24 20 2d 19 80 	movl   $0x80192d20,(%esp)
80103f72:	e8 99 07 00 00       	call   80104710 <acquire>
  wakeup1(curproc->parent);
80103f77:	8b 53 14             	mov    0x14(%ebx),%edx
80103f7a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f7d:	b8 54 2d 19 80       	mov    $0x80192d54,%eax
80103f82:	eb 10                	jmp    80103f94 <exit+0xb4>
80103f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f88:	05 c0 01 00 00       	add    $0x1c0,%eax
80103f8d:	3d 54 9d 19 80       	cmp    $0x80199d54,%eax
80103f92:	74 1e                	je     80103fb2 <exit+0xd2>
    if(p->state == SLEEPING && p->chan == chan)
80103f94:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f98:	75 ee                	jne    80103f88 <exit+0xa8>
80103f9a:	3b 50 20             	cmp    0x20(%eax),%edx
80103f9d:	75 e9                	jne    80103f88 <exit+0xa8>
      p->state = RUNNABLE;
80103f9f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fa6:	05 c0 01 00 00       	add    $0x1c0,%eax
80103fab:	3d 54 9d 19 80       	cmp    $0x80199d54,%eax
80103fb0:	75 e2                	jne    80103f94 <exit+0xb4>
      p->parent = initproc;
80103fb2:	8b 0d 54 9d 19 80    	mov    0x80199d54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fb8:	ba 54 2d 19 80       	mov    $0x80192d54,%edx
80103fbd:	eb 0f                	jmp    80103fce <exit+0xee>
80103fbf:	90                   	nop
80103fc0:	81 c2 c0 01 00 00    	add    $0x1c0,%edx
80103fc6:	81 fa 54 9d 19 80    	cmp    $0x80199d54,%edx
80103fcc:	74 3a                	je     80104008 <exit+0x128>
    if(p->parent == curproc){
80103fce:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103fd1:	75 ed                	jne    80103fc0 <exit+0xe0>
      if(p->state == ZOMBIE)
80103fd3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103fd7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103fda:	75 e4                	jne    80103fc0 <exit+0xe0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fdc:	b8 54 2d 19 80       	mov    $0x80192d54,%eax
80103fe1:	eb 11                	jmp    80103ff4 <exit+0x114>
80103fe3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fe7:	90                   	nop
80103fe8:	05 c0 01 00 00       	add    $0x1c0,%eax
80103fed:	3d 54 9d 19 80       	cmp    $0x80199d54,%eax
80103ff2:	74 cc                	je     80103fc0 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan)
80103ff4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ff8:	75 ee                	jne    80103fe8 <exit+0x108>
80103ffa:	3b 48 20             	cmp    0x20(%eax),%ecx
80103ffd:	75 e9                	jne    80103fe8 <exit+0x108>
      p->state = RUNNABLE;
80103fff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104006:	eb e0                	jmp    80103fe8 <exit+0x108>
  curproc->state = ZOMBIE;
80104008:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010400f:	e8 0c fe ff ff       	call   80103e20 <sched>
  panic("zombie exit");
80104014:	83 ec 0c             	sub    $0xc,%esp
80104017:	68 48 80 10 80       	push   $0x80108048
8010401c:	e8 5f c3 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104021:	83 ec 0c             	sub    $0xc,%esp
80104024:	68 3b 80 10 80       	push   $0x8010803b
80104029:	e8 52 c3 ff ff       	call   80100380 <panic>
8010402e:	66 90                	xchg   %ax,%ax

80104030 <wait>:
{
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	56                   	push   %esi
80104034:	53                   	push   %ebx
  pushcli();
80104035:	e8 86 05 00 00       	call   801045c0 <pushcli>
  c = mycpu();
8010403a:	e8 01 f9 ff ff       	call   80103940 <mycpu>
  p = c->proc;
8010403f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104045:	e8 c6 05 00 00       	call   80104610 <popcli>
  acquire(&ptable.lock);
8010404a:	83 ec 0c             	sub    $0xc,%esp
8010404d:	68 20 2d 19 80       	push   $0x80192d20
80104052:	e8 b9 06 00 00       	call   80104710 <acquire>
80104057:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010405a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010405c:	bb 54 2d 19 80       	mov    $0x80192d54,%ebx
80104061:	eb 13                	jmp    80104076 <wait+0x46>
80104063:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104067:	90                   	nop
80104068:	81 c3 c0 01 00 00    	add    $0x1c0,%ebx
8010406e:	81 fb 54 9d 19 80    	cmp    $0x80199d54,%ebx
80104074:	74 1e                	je     80104094 <wait+0x64>
      if(p->parent != curproc)
80104076:	39 73 14             	cmp    %esi,0x14(%ebx)
80104079:	75 ed                	jne    80104068 <wait+0x38>
      if(p->state == ZOMBIE){
8010407b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010407f:	74 5f                	je     801040e0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104081:	81 c3 c0 01 00 00    	add    $0x1c0,%ebx
      havekids = 1;
80104087:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010408c:	81 fb 54 9d 19 80    	cmp    $0x80199d54,%ebx
80104092:	75 e2                	jne    80104076 <wait+0x46>
    if(!havekids || curproc->killed){
80104094:	85 c0                	test   %eax,%eax
80104096:	0f 84 9a 00 00 00    	je     80104136 <wait+0x106>
8010409c:	8b 46 24             	mov    0x24(%esi),%eax
8010409f:	85 c0                	test   %eax,%eax
801040a1:	0f 85 8f 00 00 00    	jne    80104136 <wait+0x106>
  pushcli();
801040a7:	e8 14 05 00 00       	call   801045c0 <pushcli>
  c = mycpu();
801040ac:	e8 8f f8 ff ff       	call   80103940 <mycpu>
  p = c->proc;
801040b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040b7:	e8 54 05 00 00       	call   80104610 <popcli>
  if(p == 0)
801040bc:	85 db                	test   %ebx,%ebx
801040be:	0f 84 89 00 00 00    	je     8010414d <wait+0x11d>
  p->chan = chan;
801040c4:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
801040c7:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040ce:	e8 4d fd ff ff       	call   80103e20 <sched>
  p->chan = 0;
801040d3:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040da:	e9 7b ff ff ff       	jmp    8010405a <wait+0x2a>
801040df:	90                   	nop
        kfree(p->kstack);
801040e0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801040e3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040e6:	ff 73 08             	push   0x8(%ebx)
801040e9:	e8 e2 e3 ff ff       	call   801024d0 <kfree>
        p->kstack = 0;
801040ee:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040f5:	5a                   	pop    %edx
801040f6:	ff 73 04             	push   0x4(%ebx)
801040f9:	e8 72 32 00 00       	call   80107370 <freevm>
        p->pid = 0;
801040fe:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104105:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010410c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104110:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104117:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010411e:	c7 04 24 20 2d 19 80 	movl   $0x80192d20,(%esp)
80104125:	e8 86 05 00 00       	call   801046b0 <release>
        return pid;
8010412a:	83 c4 10             	add    $0x10,%esp
}
8010412d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104130:	89 f0                	mov    %esi,%eax
80104132:	5b                   	pop    %ebx
80104133:	5e                   	pop    %esi
80104134:	5d                   	pop    %ebp
80104135:	c3                   	ret    
      release(&ptable.lock);
80104136:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104139:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010413e:	68 20 2d 19 80       	push   $0x80192d20
80104143:	e8 68 05 00 00       	call   801046b0 <release>
      return -1;
80104148:	83 c4 10             	add    $0x10,%esp
8010414b:	eb e0                	jmp    8010412d <wait+0xfd>
    panic("sleep");
8010414d:	83 ec 0c             	sub    $0xc,%esp
80104150:	68 54 80 10 80       	push   $0x80108054
80104155:	e8 26 c2 ff ff       	call   80100380 <panic>
8010415a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104160 <yield>:
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	53                   	push   %ebx
80104164:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104167:	68 20 2d 19 80       	push   $0x80192d20
8010416c:	e8 9f 05 00 00       	call   80104710 <acquire>
  pushcli();
80104171:	e8 4a 04 00 00       	call   801045c0 <pushcli>
  c = mycpu();
80104176:	e8 c5 f7 ff ff       	call   80103940 <mycpu>
  p = c->proc;
8010417b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104181:	e8 8a 04 00 00       	call   80104610 <popcli>
  myproc()->state = RUNNABLE;
80104186:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010418d:	e8 8e fc ff ff       	call   80103e20 <sched>
  release(&ptable.lock);
80104192:	c7 04 24 20 2d 19 80 	movl   $0x80192d20,(%esp)
80104199:	e8 12 05 00 00       	call   801046b0 <release>
}
8010419e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041a1:	83 c4 10             	add    $0x10,%esp
801041a4:	c9                   	leave  
801041a5:	c3                   	ret    
801041a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ad:	8d 76 00             	lea    0x0(%esi),%esi

801041b0 <sleep>:
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	57                   	push   %edi
801041b4:	56                   	push   %esi
801041b5:	53                   	push   %ebx
801041b6:	83 ec 0c             	sub    $0xc,%esp
801041b9:	8b 7d 08             	mov    0x8(%ebp),%edi
801041bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801041bf:	e8 fc 03 00 00       	call   801045c0 <pushcli>
  c = mycpu();
801041c4:	e8 77 f7 ff ff       	call   80103940 <mycpu>
  p = c->proc;
801041c9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041cf:	e8 3c 04 00 00       	call   80104610 <popcli>
  if(p == 0)
801041d4:	85 db                	test   %ebx,%ebx
801041d6:	0f 84 87 00 00 00    	je     80104263 <sleep+0xb3>
  if(lk == 0)
801041dc:	85 f6                	test   %esi,%esi
801041de:	74 76                	je     80104256 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801041e0:	81 fe 20 2d 19 80    	cmp    $0x80192d20,%esi
801041e6:	74 50                	je     80104238 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801041e8:	83 ec 0c             	sub    $0xc,%esp
801041eb:	68 20 2d 19 80       	push   $0x80192d20
801041f0:	e8 1b 05 00 00       	call   80104710 <acquire>
    release(lk);
801041f5:	89 34 24             	mov    %esi,(%esp)
801041f8:	e8 b3 04 00 00       	call   801046b0 <release>
  p->chan = chan;
801041fd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104200:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104207:	e8 14 fc ff ff       	call   80103e20 <sched>
  p->chan = 0;
8010420c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104213:	c7 04 24 20 2d 19 80 	movl   $0x80192d20,(%esp)
8010421a:	e8 91 04 00 00       	call   801046b0 <release>
    acquire(lk);
8010421f:	89 75 08             	mov    %esi,0x8(%ebp)
80104222:	83 c4 10             	add    $0x10,%esp
}
80104225:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104228:	5b                   	pop    %ebx
80104229:	5e                   	pop    %esi
8010422a:	5f                   	pop    %edi
8010422b:	5d                   	pop    %ebp
    acquire(lk);
8010422c:	e9 df 04 00 00       	jmp    80104710 <acquire>
80104231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104238:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010423b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104242:	e8 d9 fb ff ff       	call   80103e20 <sched>
  p->chan = 0;
80104247:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010424e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104251:	5b                   	pop    %ebx
80104252:	5e                   	pop    %esi
80104253:	5f                   	pop    %edi
80104254:	5d                   	pop    %ebp
80104255:	c3                   	ret    
    panic("sleep without lk");
80104256:	83 ec 0c             	sub    $0xc,%esp
80104259:	68 5a 80 10 80       	push   $0x8010805a
8010425e:	e8 1d c1 ff ff       	call   80100380 <panic>
    panic("sleep");
80104263:	83 ec 0c             	sub    $0xc,%esp
80104266:	68 54 80 10 80       	push   $0x80108054
8010426b:	e8 10 c1 ff ff       	call   80100380 <panic>

80104270 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	53                   	push   %ebx
80104274:	83 ec 10             	sub    $0x10,%esp
80104277:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010427a:	68 20 2d 19 80       	push   $0x80192d20
8010427f:	e8 8c 04 00 00       	call   80104710 <acquire>
80104284:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104287:	b8 54 2d 19 80       	mov    $0x80192d54,%eax
8010428c:	eb 0e                	jmp    8010429c <wakeup+0x2c>
8010428e:	66 90                	xchg   %ax,%ax
80104290:	05 c0 01 00 00       	add    $0x1c0,%eax
80104295:	3d 54 9d 19 80       	cmp    $0x80199d54,%eax
8010429a:	74 1e                	je     801042ba <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010429c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042a0:	75 ee                	jne    80104290 <wakeup+0x20>
801042a2:	3b 58 20             	cmp    0x20(%eax),%ebx
801042a5:	75 e9                	jne    80104290 <wakeup+0x20>
      p->state = RUNNABLE;
801042a7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042ae:	05 c0 01 00 00       	add    $0x1c0,%eax
801042b3:	3d 54 9d 19 80       	cmp    $0x80199d54,%eax
801042b8:	75 e2                	jne    8010429c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801042ba:	c7 45 08 20 2d 19 80 	movl   $0x80192d20,0x8(%ebp)
}
801042c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042c4:	c9                   	leave  
  release(&ptable.lock);
801042c5:	e9 e6 03 00 00       	jmp    801046b0 <release>
801042ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042d0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	53                   	push   %ebx
801042d4:	83 ec 10             	sub    $0x10,%esp
801042d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801042da:	68 20 2d 19 80       	push   $0x80192d20
801042df:	e8 2c 04 00 00       	call   80104710 <acquire>
801042e4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042e7:	b8 54 2d 19 80       	mov    $0x80192d54,%eax
801042ec:	eb 0e                	jmp    801042fc <kill+0x2c>
801042ee:	66 90                	xchg   %ax,%ax
801042f0:	05 c0 01 00 00       	add    $0x1c0,%eax
801042f5:	3d 54 9d 19 80       	cmp    $0x80199d54,%eax
801042fa:	74 34                	je     80104330 <kill+0x60>
    if(p->pid == pid){
801042fc:	39 58 10             	cmp    %ebx,0x10(%eax)
801042ff:	75 ef                	jne    801042f0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104301:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104305:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010430c:	75 07                	jne    80104315 <kill+0x45>
        p->state = RUNNABLE;
8010430e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104315:	83 ec 0c             	sub    $0xc,%esp
80104318:	68 20 2d 19 80       	push   $0x80192d20
8010431d:	e8 8e 03 00 00       	call   801046b0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104322:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104325:	83 c4 10             	add    $0x10,%esp
80104328:	31 c0                	xor    %eax,%eax
}
8010432a:	c9                   	leave  
8010432b:	c3                   	ret    
8010432c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104330:	83 ec 0c             	sub    $0xc,%esp
80104333:	68 20 2d 19 80       	push   $0x80192d20
80104338:	e8 73 03 00 00       	call   801046b0 <release>
}
8010433d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104340:	83 c4 10             	add    $0x10,%esp
80104343:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104348:	c9                   	leave  
80104349:	c3                   	ret    
8010434a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104350 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	57                   	push   %edi
80104354:	56                   	push   %esi
80104355:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104358:	53                   	push   %ebx
80104359:	bb c0 2d 19 80       	mov    $0x80192dc0,%ebx
8010435e:	83 ec 3c             	sub    $0x3c,%esp
80104361:	eb 27                	jmp    8010438a <procdump+0x3a>
80104363:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104367:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104368:	83 ec 0c             	sub    $0xc,%esp
8010436b:	68 1f 82 10 80       	push   $0x8010821f
80104370:	e8 2b c3 ff ff       	call   801006a0 <cprintf>
80104375:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104378:	81 c3 c0 01 00 00    	add    $0x1c0,%ebx
8010437e:	81 fb c0 9d 19 80    	cmp    $0x80199dc0,%ebx
80104384:	0f 84 7e 00 00 00    	je     80104408 <procdump+0xb8>
    if(p->state == UNUSED)
8010438a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010438d:	85 c0                	test   %eax,%eax
8010438f:	74 e7                	je     80104378 <procdump+0x28>
      state = "???";
80104391:	ba 6b 80 10 80       	mov    $0x8010806b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104396:	83 f8 05             	cmp    $0x5,%eax
80104399:	77 11                	ja     801043ac <procdump+0x5c>
8010439b:	8b 14 85 cc 80 10 80 	mov    -0x7fef7f34(,%eax,4),%edx
      state = "???";
801043a2:	b8 6b 80 10 80       	mov    $0x8010806b,%eax
801043a7:	85 d2                	test   %edx,%edx
801043a9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801043ac:	53                   	push   %ebx
801043ad:	52                   	push   %edx
801043ae:	ff 73 a4             	push   -0x5c(%ebx)
801043b1:	68 6f 80 10 80       	push   $0x8010806f
801043b6:	e8 e5 c2 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
801043bb:	83 c4 10             	add    $0x10,%esp
801043be:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801043c2:	75 a4                	jne    80104368 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801043c4:	83 ec 08             	sub    $0x8,%esp
801043c7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801043ca:	8d 7d c0             	lea    -0x40(%ebp),%edi
801043cd:	50                   	push   %eax
801043ce:	8b 43 b0             	mov    -0x50(%ebx),%eax
801043d1:	8b 40 0c             	mov    0xc(%eax),%eax
801043d4:	83 c0 08             	add    $0x8,%eax
801043d7:	50                   	push   %eax
801043d8:	e8 83 01 00 00       	call   80104560 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801043dd:	83 c4 10             	add    $0x10,%esp
801043e0:	8b 17                	mov    (%edi),%edx
801043e2:	85 d2                	test   %edx,%edx
801043e4:	74 82                	je     80104368 <procdump+0x18>
        cprintf(" %p", pc[i]);
801043e6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801043e9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801043ec:	52                   	push   %edx
801043ed:	68 c1 7a 10 80       	push   $0x80107ac1
801043f2:	e8 a9 c2 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801043f7:	83 c4 10             	add    $0x10,%esp
801043fa:	39 fe                	cmp    %edi,%esi
801043fc:	75 e2                	jne    801043e0 <procdump+0x90>
801043fe:	e9 65 ff ff ff       	jmp    80104368 <procdump+0x18>
80104403:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104407:	90                   	nop
  }
}
80104408:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010440b:	5b                   	pop    %ebx
8010440c:	5e                   	pop    %esi
8010440d:	5f                   	pop    %edi
8010440e:	5d                   	pop    %ebp
8010440f:	c3                   	ret    

80104410 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	53                   	push   %ebx
80104414:	83 ec 0c             	sub    $0xc,%esp
80104417:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010441a:	68 e4 80 10 80       	push   $0x801080e4
8010441f:	8d 43 04             	lea    0x4(%ebx),%eax
80104422:	50                   	push   %eax
80104423:	e8 18 01 00 00       	call   80104540 <initlock>
  lk->name = name;
80104428:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010442b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104431:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104434:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010443b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010443e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104441:	c9                   	leave  
80104442:	c3                   	ret    
80104443:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010444a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104450 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	56                   	push   %esi
80104454:	53                   	push   %ebx
80104455:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104458:	8d 73 04             	lea    0x4(%ebx),%esi
8010445b:	83 ec 0c             	sub    $0xc,%esp
8010445e:	56                   	push   %esi
8010445f:	e8 ac 02 00 00       	call   80104710 <acquire>
  while (lk->locked) {
80104464:	8b 13                	mov    (%ebx),%edx
80104466:	83 c4 10             	add    $0x10,%esp
80104469:	85 d2                	test   %edx,%edx
8010446b:	74 16                	je     80104483 <acquiresleep+0x33>
8010446d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104470:	83 ec 08             	sub    $0x8,%esp
80104473:	56                   	push   %esi
80104474:	53                   	push   %ebx
80104475:	e8 36 fd ff ff       	call   801041b0 <sleep>
  while (lk->locked) {
8010447a:	8b 03                	mov    (%ebx),%eax
8010447c:	83 c4 10             	add    $0x10,%esp
8010447f:	85 c0                	test   %eax,%eax
80104481:	75 ed                	jne    80104470 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104483:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104489:	e8 32 f5 ff ff       	call   801039c0 <myproc>
8010448e:	8b 40 10             	mov    0x10(%eax),%eax
80104491:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104494:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104497:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010449a:	5b                   	pop    %ebx
8010449b:	5e                   	pop    %esi
8010449c:	5d                   	pop    %ebp
  release(&lk->lk);
8010449d:	e9 0e 02 00 00       	jmp    801046b0 <release>
801044a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044b0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	56                   	push   %esi
801044b4:	53                   	push   %ebx
801044b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044b8:	8d 73 04             	lea    0x4(%ebx),%esi
801044bb:	83 ec 0c             	sub    $0xc,%esp
801044be:	56                   	push   %esi
801044bf:	e8 4c 02 00 00       	call   80104710 <acquire>
  lk->locked = 0;
801044c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801044ca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801044d1:	89 1c 24             	mov    %ebx,(%esp)
801044d4:	e8 97 fd ff ff       	call   80104270 <wakeup>
  release(&lk->lk);
801044d9:	89 75 08             	mov    %esi,0x8(%ebp)
801044dc:	83 c4 10             	add    $0x10,%esp
}
801044df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044e2:	5b                   	pop    %ebx
801044e3:	5e                   	pop    %esi
801044e4:	5d                   	pop    %ebp
  release(&lk->lk);
801044e5:	e9 c6 01 00 00       	jmp    801046b0 <release>
801044ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	57                   	push   %edi
801044f4:	31 ff                	xor    %edi,%edi
801044f6:	56                   	push   %esi
801044f7:	53                   	push   %ebx
801044f8:	83 ec 18             	sub    $0x18,%esp
801044fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801044fe:	8d 73 04             	lea    0x4(%ebx),%esi
80104501:	56                   	push   %esi
80104502:	e8 09 02 00 00       	call   80104710 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104507:	8b 03                	mov    (%ebx),%eax
80104509:	83 c4 10             	add    $0x10,%esp
8010450c:	85 c0                	test   %eax,%eax
8010450e:	75 18                	jne    80104528 <holdingsleep+0x38>
  release(&lk->lk);
80104510:	83 ec 0c             	sub    $0xc,%esp
80104513:	56                   	push   %esi
80104514:	e8 97 01 00 00       	call   801046b0 <release>
  return r;
}
80104519:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010451c:	89 f8                	mov    %edi,%eax
8010451e:	5b                   	pop    %ebx
8010451f:	5e                   	pop    %esi
80104520:	5f                   	pop    %edi
80104521:	5d                   	pop    %ebp
80104522:	c3                   	ret    
80104523:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104527:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104528:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010452b:	e8 90 f4 ff ff       	call   801039c0 <myproc>
80104530:	39 58 10             	cmp    %ebx,0x10(%eax)
80104533:	0f 94 c0             	sete   %al
80104536:	0f b6 c0             	movzbl %al,%eax
80104539:	89 c7                	mov    %eax,%edi
8010453b:	eb d3                	jmp    80104510 <holdingsleep+0x20>
8010453d:	66 90                	xchg   %ax,%ax
8010453f:	90                   	nop

80104540 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104546:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104549:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010454f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104552:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104559:	5d                   	pop    %ebp
8010455a:	c3                   	ret    
8010455b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010455f:	90                   	nop

80104560 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104560:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104561:	31 d2                	xor    %edx,%edx
{
80104563:	89 e5                	mov    %esp,%ebp
80104565:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104566:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104569:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010456c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010456f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104570:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104576:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010457c:	77 1a                	ja     80104598 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010457e:	8b 58 04             	mov    0x4(%eax),%ebx
80104581:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104584:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104587:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104589:	83 fa 0a             	cmp    $0xa,%edx
8010458c:	75 e2                	jne    80104570 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010458e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104591:	c9                   	leave  
80104592:	c3                   	ret    
80104593:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104597:	90                   	nop
  for(; i < 10; i++)
80104598:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010459b:	8d 51 28             	lea    0x28(%ecx),%edx
8010459e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801045a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801045a6:	83 c0 04             	add    $0x4,%eax
801045a9:	39 d0                	cmp    %edx,%eax
801045ab:	75 f3                	jne    801045a0 <getcallerpcs+0x40>
}
801045ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045b0:	c9                   	leave  
801045b1:	c3                   	ret    
801045b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	53                   	push   %ebx
801045c4:	83 ec 04             	sub    $0x4,%esp
801045c7:	9c                   	pushf  
801045c8:	5b                   	pop    %ebx
  asm volatile("cli");
801045c9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801045ca:	e8 71 f3 ff ff       	call   80103940 <mycpu>
801045cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801045d5:	85 c0                	test   %eax,%eax
801045d7:	74 17                	je     801045f0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801045d9:	e8 62 f3 ff ff       	call   80103940 <mycpu>
801045de:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801045e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045e8:	c9                   	leave  
801045e9:	c3                   	ret    
801045ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801045f0:	e8 4b f3 ff ff       	call   80103940 <mycpu>
801045f5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801045fb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104601:	eb d6                	jmp    801045d9 <pushcli+0x19>
80104603:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010460a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104610 <popcli>:

void
popcli(void)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104616:	9c                   	pushf  
80104617:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104618:	f6 c4 02             	test   $0x2,%ah
8010461b:	75 35                	jne    80104652 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010461d:	e8 1e f3 ff ff       	call   80103940 <mycpu>
80104622:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104629:	78 34                	js     8010465f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010462b:	e8 10 f3 ff ff       	call   80103940 <mycpu>
80104630:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104636:	85 d2                	test   %edx,%edx
80104638:	74 06                	je     80104640 <popcli+0x30>
    sti();
}
8010463a:	c9                   	leave  
8010463b:	c3                   	ret    
8010463c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104640:	e8 fb f2 ff ff       	call   80103940 <mycpu>
80104645:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010464b:	85 c0                	test   %eax,%eax
8010464d:	74 eb                	je     8010463a <popcli+0x2a>
  asm volatile("sti");
8010464f:	fb                   	sti    
}
80104650:	c9                   	leave  
80104651:	c3                   	ret    
    panic("popcli - interruptible");
80104652:	83 ec 0c             	sub    $0xc,%esp
80104655:	68 ef 80 10 80       	push   $0x801080ef
8010465a:	e8 21 bd ff ff       	call   80100380 <panic>
    panic("popcli");
8010465f:	83 ec 0c             	sub    $0xc,%esp
80104662:	68 06 81 10 80       	push   $0x80108106
80104667:	e8 14 bd ff ff       	call   80100380 <panic>
8010466c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104670 <holding>:
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	56                   	push   %esi
80104674:	53                   	push   %ebx
80104675:	8b 75 08             	mov    0x8(%ebp),%esi
80104678:	31 db                	xor    %ebx,%ebx
  pushcli();
8010467a:	e8 41 ff ff ff       	call   801045c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010467f:	8b 06                	mov    (%esi),%eax
80104681:	85 c0                	test   %eax,%eax
80104683:	75 0b                	jne    80104690 <holding+0x20>
  popcli();
80104685:	e8 86 ff ff ff       	call   80104610 <popcli>
}
8010468a:	89 d8                	mov    %ebx,%eax
8010468c:	5b                   	pop    %ebx
8010468d:	5e                   	pop    %esi
8010468e:	5d                   	pop    %ebp
8010468f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104690:	8b 5e 08             	mov    0x8(%esi),%ebx
80104693:	e8 a8 f2 ff ff       	call   80103940 <mycpu>
80104698:	39 c3                	cmp    %eax,%ebx
8010469a:	0f 94 c3             	sete   %bl
  popcli();
8010469d:	e8 6e ff ff ff       	call   80104610 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801046a2:	0f b6 db             	movzbl %bl,%ebx
}
801046a5:	89 d8                	mov    %ebx,%eax
801046a7:	5b                   	pop    %ebx
801046a8:	5e                   	pop    %esi
801046a9:	5d                   	pop    %ebp
801046aa:	c3                   	ret    
801046ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046af:	90                   	nop

801046b0 <release>:
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	56                   	push   %esi
801046b4:	53                   	push   %ebx
801046b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801046b8:	e8 03 ff ff ff       	call   801045c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046bd:	8b 03                	mov    (%ebx),%eax
801046bf:	85 c0                	test   %eax,%eax
801046c1:	75 15                	jne    801046d8 <release+0x28>
  popcli();
801046c3:	e8 48 ff ff ff       	call   80104610 <popcli>
    panic("release");
801046c8:	83 ec 0c             	sub    $0xc,%esp
801046cb:	68 0d 81 10 80       	push   $0x8010810d
801046d0:	e8 ab bc ff ff       	call   80100380 <panic>
801046d5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801046d8:	8b 73 08             	mov    0x8(%ebx),%esi
801046db:	e8 60 f2 ff ff       	call   80103940 <mycpu>
801046e0:	39 c6                	cmp    %eax,%esi
801046e2:	75 df                	jne    801046c3 <release+0x13>
  popcli();
801046e4:	e8 27 ff ff ff       	call   80104610 <popcli>
  lk->pcs[0] = 0;
801046e9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801046f0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801046f7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801046fc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104702:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104705:	5b                   	pop    %ebx
80104706:	5e                   	pop    %esi
80104707:	5d                   	pop    %ebp
  popcli();
80104708:	e9 03 ff ff ff       	jmp    80104610 <popcli>
8010470d:	8d 76 00             	lea    0x0(%esi),%esi

80104710 <acquire>:
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	53                   	push   %ebx
80104714:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104717:	e8 a4 fe ff ff       	call   801045c0 <pushcli>
  if(holding(lk))
8010471c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010471f:	e8 9c fe ff ff       	call   801045c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104724:	8b 03                	mov    (%ebx),%eax
80104726:	85 c0                	test   %eax,%eax
80104728:	75 7e                	jne    801047a8 <acquire+0x98>
  popcli();
8010472a:	e8 e1 fe ff ff       	call   80104610 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010472f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104738:	8b 55 08             	mov    0x8(%ebp),%edx
8010473b:	89 c8                	mov    %ecx,%eax
8010473d:	f0 87 02             	lock xchg %eax,(%edx)
80104740:	85 c0                	test   %eax,%eax
80104742:	75 f4                	jne    80104738 <acquire+0x28>
  __sync_synchronize();
80104744:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104749:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010474c:	e8 ef f1 ff ff       	call   80103940 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104751:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104754:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104756:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104759:	31 c0                	xor    %eax,%eax
8010475b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010475f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104760:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104766:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010476c:	77 1a                	ja     80104788 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010476e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104771:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104775:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104778:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010477a:	83 f8 0a             	cmp    $0xa,%eax
8010477d:	75 e1                	jne    80104760 <acquire+0x50>
}
8010477f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104782:	c9                   	leave  
80104783:	c3                   	ret    
80104784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104788:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010478c:	8d 51 34             	lea    0x34(%ecx),%edx
8010478f:	90                   	nop
    pcs[i] = 0;
80104790:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104796:	83 c0 04             	add    $0x4,%eax
80104799:	39 c2                	cmp    %eax,%edx
8010479b:	75 f3                	jne    80104790 <acquire+0x80>
}
8010479d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047a0:	c9                   	leave  
801047a1:	c3                   	ret    
801047a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801047a8:	8b 5b 08             	mov    0x8(%ebx),%ebx
801047ab:	e8 90 f1 ff ff       	call   80103940 <mycpu>
801047b0:	39 c3                	cmp    %eax,%ebx
801047b2:	0f 85 72 ff ff ff    	jne    8010472a <acquire+0x1a>
  popcli();
801047b8:	e8 53 fe ff ff       	call   80104610 <popcli>
    panic("acquire");
801047bd:	83 ec 0c             	sub    $0xc,%esp
801047c0:	68 15 81 10 80       	push   $0x80108115
801047c5:	e8 b6 bb ff ff       	call   80100380 <panic>
801047ca:	66 90                	xchg   %ax,%ax
801047cc:	66 90                	xchg   %ax,%ax
801047ce:	66 90                	xchg   %ax,%ax

801047d0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	57                   	push   %edi
801047d4:	8b 55 08             	mov    0x8(%ebp),%edx
801047d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047da:	53                   	push   %ebx
801047db:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801047de:	89 d7                	mov    %edx,%edi
801047e0:	09 cf                	or     %ecx,%edi
801047e2:	83 e7 03             	and    $0x3,%edi
801047e5:	75 29                	jne    80104810 <memset+0x40>
    c &= 0xFF;
801047e7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801047ea:	c1 e0 18             	shl    $0x18,%eax
801047ed:	89 fb                	mov    %edi,%ebx
801047ef:	c1 e9 02             	shr    $0x2,%ecx
801047f2:	c1 e3 10             	shl    $0x10,%ebx
801047f5:	09 d8                	or     %ebx,%eax
801047f7:	09 f8                	or     %edi,%eax
801047f9:	c1 e7 08             	shl    $0x8,%edi
801047fc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801047fe:	89 d7                	mov    %edx,%edi
80104800:	fc                   	cld    
80104801:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104803:	5b                   	pop    %ebx
80104804:	89 d0                	mov    %edx,%eax
80104806:	5f                   	pop    %edi
80104807:	5d                   	pop    %ebp
80104808:	c3                   	ret    
80104809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104810:	89 d7                	mov    %edx,%edi
80104812:	fc                   	cld    
80104813:	f3 aa                	rep stos %al,%es:(%edi)
80104815:	5b                   	pop    %ebx
80104816:	89 d0                	mov    %edx,%eax
80104818:	5f                   	pop    %edi
80104819:	5d                   	pop    %ebp
8010481a:	c3                   	ret    
8010481b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010481f:	90                   	nop

80104820 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	56                   	push   %esi
80104824:	8b 75 10             	mov    0x10(%ebp),%esi
80104827:	8b 55 08             	mov    0x8(%ebp),%edx
8010482a:	53                   	push   %ebx
8010482b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010482e:	85 f6                	test   %esi,%esi
80104830:	74 2e                	je     80104860 <memcmp+0x40>
80104832:	01 c6                	add    %eax,%esi
80104834:	eb 14                	jmp    8010484a <memcmp+0x2a>
80104836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010483d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104840:	83 c0 01             	add    $0x1,%eax
80104843:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104846:	39 f0                	cmp    %esi,%eax
80104848:	74 16                	je     80104860 <memcmp+0x40>
    if(*s1 != *s2)
8010484a:	0f b6 0a             	movzbl (%edx),%ecx
8010484d:	0f b6 18             	movzbl (%eax),%ebx
80104850:	38 d9                	cmp    %bl,%cl
80104852:	74 ec                	je     80104840 <memcmp+0x20>
      return *s1 - *s2;
80104854:	0f b6 c1             	movzbl %cl,%eax
80104857:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104859:	5b                   	pop    %ebx
8010485a:	5e                   	pop    %esi
8010485b:	5d                   	pop    %ebp
8010485c:	c3                   	ret    
8010485d:	8d 76 00             	lea    0x0(%esi),%esi
80104860:	5b                   	pop    %ebx
  return 0;
80104861:	31 c0                	xor    %eax,%eax
}
80104863:	5e                   	pop    %esi
80104864:	5d                   	pop    %ebp
80104865:	c3                   	ret    
80104866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010486d:	8d 76 00             	lea    0x0(%esi),%esi

80104870 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	57                   	push   %edi
80104874:	8b 55 08             	mov    0x8(%ebp),%edx
80104877:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010487a:	56                   	push   %esi
8010487b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010487e:	39 d6                	cmp    %edx,%esi
80104880:	73 26                	jae    801048a8 <memmove+0x38>
80104882:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104885:	39 fa                	cmp    %edi,%edx
80104887:	73 1f                	jae    801048a8 <memmove+0x38>
80104889:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010488c:	85 c9                	test   %ecx,%ecx
8010488e:	74 0c                	je     8010489c <memmove+0x2c>
      *--d = *--s;
80104890:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104894:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104897:	83 e8 01             	sub    $0x1,%eax
8010489a:	73 f4                	jae    80104890 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010489c:	5e                   	pop    %esi
8010489d:	89 d0                	mov    %edx,%eax
8010489f:	5f                   	pop    %edi
801048a0:	5d                   	pop    %ebp
801048a1:	c3                   	ret    
801048a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801048a8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801048ab:	89 d7                	mov    %edx,%edi
801048ad:	85 c9                	test   %ecx,%ecx
801048af:	74 eb                	je     8010489c <memmove+0x2c>
801048b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801048b8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801048b9:	39 c6                	cmp    %eax,%esi
801048bb:	75 fb                	jne    801048b8 <memmove+0x48>
}
801048bd:	5e                   	pop    %esi
801048be:	89 d0                	mov    %edx,%eax
801048c0:	5f                   	pop    %edi
801048c1:	5d                   	pop    %ebp
801048c2:	c3                   	ret    
801048c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048d0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801048d0:	eb 9e                	jmp    80104870 <memmove>
801048d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801048e0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	8b 75 10             	mov    0x10(%ebp),%esi
801048e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801048ea:	53                   	push   %ebx
801048eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801048ee:	85 f6                	test   %esi,%esi
801048f0:	74 2e                	je     80104920 <strncmp+0x40>
801048f2:	01 d6                	add    %edx,%esi
801048f4:	eb 18                	jmp    8010490e <strncmp+0x2e>
801048f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048fd:	8d 76 00             	lea    0x0(%esi),%esi
80104900:	38 d8                	cmp    %bl,%al
80104902:	75 14                	jne    80104918 <strncmp+0x38>
    n--, p++, q++;
80104904:	83 c2 01             	add    $0x1,%edx
80104907:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010490a:	39 f2                	cmp    %esi,%edx
8010490c:	74 12                	je     80104920 <strncmp+0x40>
8010490e:	0f b6 01             	movzbl (%ecx),%eax
80104911:	0f b6 1a             	movzbl (%edx),%ebx
80104914:	84 c0                	test   %al,%al
80104916:	75 e8                	jne    80104900 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104918:	29 d8                	sub    %ebx,%eax
}
8010491a:	5b                   	pop    %ebx
8010491b:	5e                   	pop    %esi
8010491c:	5d                   	pop    %ebp
8010491d:	c3                   	ret    
8010491e:	66 90                	xchg   %ax,%ax
80104920:	5b                   	pop    %ebx
    return 0;
80104921:	31 c0                	xor    %eax,%eax
}
80104923:	5e                   	pop    %esi
80104924:	5d                   	pop    %ebp
80104925:	c3                   	ret    
80104926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492d:	8d 76 00             	lea    0x0(%esi),%esi

80104930 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	57                   	push   %edi
80104934:	56                   	push   %esi
80104935:	8b 75 08             	mov    0x8(%ebp),%esi
80104938:	53                   	push   %ebx
80104939:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010493c:	89 f0                	mov    %esi,%eax
8010493e:	eb 15                	jmp    80104955 <strncpy+0x25>
80104940:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104944:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104947:	83 c0 01             	add    $0x1,%eax
8010494a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010494e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104951:	84 d2                	test   %dl,%dl
80104953:	74 09                	je     8010495e <strncpy+0x2e>
80104955:	89 cb                	mov    %ecx,%ebx
80104957:	83 e9 01             	sub    $0x1,%ecx
8010495a:	85 db                	test   %ebx,%ebx
8010495c:	7f e2                	jg     80104940 <strncpy+0x10>
    ;
  while(n-- > 0)
8010495e:	89 c2                	mov    %eax,%edx
80104960:	85 c9                	test   %ecx,%ecx
80104962:	7e 17                	jle    8010497b <strncpy+0x4b>
80104964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104968:	83 c2 01             	add    $0x1,%edx
8010496b:	89 c1                	mov    %eax,%ecx
8010496d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104971:	29 d1                	sub    %edx,%ecx
80104973:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104977:	85 c9                	test   %ecx,%ecx
80104979:	7f ed                	jg     80104968 <strncpy+0x38>
  return os;
}
8010497b:	5b                   	pop    %ebx
8010497c:	89 f0                	mov    %esi,%eax
8010497e:	5e                   	pop    %esi
8010497f:	5f                   	pop    %edi
80104980:	5d                   	pop    %ebp
80104981:	c3                   	ret    
80104982:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104990 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	56                   	push   %esi
80104994:	8b 55 10             	mov    0x10(%ebp),%edx
80104997:	8b 75 08             	mov    0x8(%ebp),%esi
8010499a:	53                   	push   %ebx
8010499b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010499e:	85 d2                	test   %edx,%edx
801049a0:	7e 25                	jle    801049c7 <safestrcpy+0x37>
801049a2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801049a6:	89 f2                	mov    %esi,%edx
801049a8:	eb 16                	jmp    801049c0 <safestrcpy+0x30>
801049aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801049b0:	0f b6 08             	movzbl (%eax),%ecx
801049b3:	83 c0 01             	add    $0x1,%eax
801049b6:	83 c2 01             	add    $0x1,%edx
801049b9:	88 4a ff             	mov    %cl,-0x1(%edx)
801049bc:	84 c9                	test   %cl,%cl
801049be:	74 04                	je     801049c4 <safestrcpy+0x34>
801049c0:	39 d8                	cmp    %ebx,%eax
801049c2:	75 ec                	jne    801049b0 <safestrcpy+0x20>
    ;
  *s = 0;
801049c4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801049c7:	89 f0                	mov    %esi,%eax
801049c9:	5b                   	pop    %ebx
801049ca:	5e                   	pop    %esi
801049cb:	5d                   	pop    %ebp
801049cc:	c3                   	ret    
801049cd:	8d 76 00             	lea    0x0(%esi),%esi

801049d0 <strlen>:

int
strlen(const char *s)
{
801049d0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801049d1:	31 c0                	xor    %eax,%eax
{
801049d3:	89 e5                	mov    %esp,%ebp
801049d5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801049d8:	80 3a 00             	cmpb   $0x0,(%edx)
801049db:	74 0c                	je     801049e9 <strlen+0x19>
801049dd:	8d 76 00             	lea    0x0(%esi),%esi
801049e0:	83 c0 01             	add    $0x1,%eax
801049e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801049e7:	75 f7                	jne    801049e0 <strlen+0x10>
    ;
  return n;
}
801049e9:	5d                   	pop    %ebp
801049ea:	c3                   	ret    

801049eb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801049eb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801049ef:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801049f3:	55                   	push   %ebp
  pushl %ebx
801049f4:	53                   	push   %ebx
  pushl %esi
801049f5:	56                   	push   %esi
  pushl %edi
801049f6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801049f7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801049f9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801049fb:	5f                   	pop    %edi
  popl %esi
801049fc:	5e                   	pop    %esi
  popl %ebx
801049fd:	5b                   	pop    %ebx
  popl %ebp
801049fe:	5d                   	pop    %ebp
  ret
801049ff:	c3                   	ret    

80104a00 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	53                   	push   %ebx
80104a04:	83 ec 04             	sub    $0x4,%esp
80104a07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a0a:	e8 b1 ef ff ff       	call   801039c0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a0f:	8b 00                	mov    (%eax),%eax
80104a11:	39 d8                	cmp    %ebx,%eax
80104a13:	76 1b                	jbe    80104a30 <fetchint+0x30>
80104a15:	8d 53 04             	lea    0x4(%ebx),%edx
80104a18:	39 d0                	cmp    %edx,%eax
80104a1a:	72 14                	jb     80104a30 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a1f:	8b 13                	mov    (%ebx),%edx
80104a21:	89 10                	mov    %edx,(%eax)
  return 0;
80104a23:	31 c0                	xor    %eax,%eax
}
80104a25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a28:	c9                   	leave  
80104a29:	c3                   	ret    
80104a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a35:	eb ee                	jmp    80104a25 <fetchint+0x25>
80104a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a3e:	66 90                	xchg   %ax,%ax

80104a40 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	53                   	push   %ebx
80104a44:	83 ec 04             	sub    $0x4,%esp
80104a47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a4a:	e8 71 ef ff ff       	call   801039c0 <myproc>

  if(addr >= curproc->sz)
80104a4f:	39 18                	cmp    %ebx,(%eax)
80104a51:	76 2d                	jbe    80104a80 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104a53:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a56:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a58:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a5a:	39 d3                	cmp    %edx,%ebx
80104a5c:	73 22                	jae    80104a80 <fetchstr+0x40>
80104a5e:	89 d8                	mov    %ebx,%eax
80104a60:	eb 0d                	jmp    80104a6f <fetchstr+0x2f>
80104a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a68:	83 c0 01             	add    $0x1,%eax
80104a6b:	39 c2                	cmp    %eax,%edx
80104a6d:	76 11                	jbe    80104a80 <fetchstr+0x40>
    if(*s == 0)
80104a6f:	80 38 00             	cmpb   $0x0,(%eax)
80104a72:	75 f4                	jne    80104a68 <fetchstr+0x28>
      return s - *pp;
80104a74:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104a76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a79:	c9                   	leave  
80104a7a:	c3                   	ret    
80104a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a7f:	90                   	nop
80104a80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104a83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a88:	c9                   	leave  
80104a89:	c3                   	ret    
80104a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a90 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	56                   	push   %esi
80104a94:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a95:	e8 26 ef ff ff       	call   801039c0 <myproc>
80104a9a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a9d:	8b 40 18             	mov    0x18(%eax),%eax
80104aa0:	8b 40 44             	mov    0x44(%eax),%eax
80104aa3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104aa6:	e8 15 ef ff ff       	call   801039c0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104aab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104aae:	8b 00                	mov    (%eax),%eax
80104ab0:	39 c6                	cmp    %eax,%esi
80104ab2:	73 1c                	jae    80104ad0 <argint+0x40>
80104ab4:	8d 53 08             	lea    0x8(%ebx),%edx
80104ab7:	39 d0                	cmp    %edx,%eax
80104ab9:	72 15                	jb     80104ad0 <argint+0x40>
  *ip = *(int*)(addr);
80104abb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104abe:	8b 53 04             	mov    0x4(%ebx),%edx
80104ac1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ac3:	31 c0                	xor    %eax,%eax
}
80104ac5:	5b                   	pop    %ebx
80104ac6:	5e                   	pop    %esi
80104ac7:	5d                   	pop    %ebp
80104ac8:	c3                   	ret    
80104ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ad5:	eb ee                	jmp    80104ac5 <argint+0x35>
80104ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ade:	66 90                	xchg   %ax,%ax

80104ae0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	57                   	push   %edi
80104ae4:	56                   	push   %esi
80104ae5:	53                   	push   %ebx
80104ae6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104ae9:	e8 d2 ee ff ff       	call   801039c0 <myproc>
80104aee:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104af0:	e8 cb ee ff ff       	call   801039c0 <myproc>
80104af5:	8b 55 08             	mov    0x8(%ebp),%edx
80104af8:	8b 40 18             	mov    0x18(%eax),%eax
80104afb:	8b 40 44             	mov    0x44(%eax),%eax
80104afe:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b01:	e8 ba ee ff ff       	call   801039c0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b06:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b09:	8b 00                	mov    (%eax),%eax
80104b0b:	39 c7                	cmp    %eax,%edi
80104b0d:	73 31                	jae    80104b40 <argptr+0x60>
80104b0f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104b12:	39 c8                	cmp    %ecx,%eax
80104b14:	72 2a                	jb     80104b40 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b16:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104b19:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b1c:	85 d2                	test   %edx,%edx
80104b1e:	78 20                	js     80104b40 <argptr+0x60>
80104b20:	8b 16                	mov    (%esi),%edx
80104b22:	39 c2                	cmp    %eax,%edx
80104b24:	76 1a                	jbe    80104b40 <argptr+0x60>
80104b26:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104b29:	01 c3                	add    %eax,%ebx
80104b2b:	39 da                	cmp    %ebx,%edx
80104b2d:	72 11                	jb     80104b40 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104b2f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b32:	89 02                	mov    %eax,(%edx)
  return 0;
80104b34:	31 c0                	xor    %eax,%eax
}
80104b36:	83 c4 0c             	add    $0xc,%esp
80104b39:	5b                   	pop    %ebx
80104b3a:	5e                   	pop    %esi
80104b3b:	5f                   	pop    %edi
80104b3c:	5d                   	pop    %ebp
80104b3d:	c3                   	ret    
80104b3e:	66 90                	xchg   %ax,%ax
    return -1;
80104b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b45:	eb ef                	jmp    80104b36 <argptr+0x56>
80104b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b4e:	66 90                	xchg   %ax,%ax

80104b50 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	56                   	push   %esi
80104b54:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b55:	e8 66 ee ff ff       	call   801039c0 <myproc>
80104b5a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b5d:	8b 40 18             	mov    0x18(%eax),%eax
80104b60:	8b 40 44             	mov    0x44(%eax),%eax
80104b63:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b66:	e8 55 ee ff ff       	call   801039c0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b6b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b6e:	8b 00                	mov    (%eax),%eax
80104b70:	39 c6                	cmp    %eax,%esi
80104b72:	73 44                	jae    80104bb8 <argstr+0x68>
80104b74:	8d 53 08             	lea    0x8(%ebx),%edx
80104b77:	39 d0                	cmp    %edx,%eax
80104b79:	72 3d                	jb     80104bb8 <argstr+0x68>
  *ip = *(int*)(addr);
80104b7b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104b7e:	e8 3d ee ff ff       	call   801039c0 <myproc>
  if(addr >= curproc->sz)
80104b83:	3b 18                	cmp    (%eax),%ebx
80104b85:	73 31                	jae    80104bb8 <argstr+0x68>
  *pp = (char*)addr;
80104b87:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b8a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b8c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b8e:	39 d3                	cmp    %edx,%ebx
80104b90:	73 26                	jae    80104bb8 <argstr+0x68>
80104b92:	89 d8                	mov    %ebx,%eax
80104b94:	eb 11                	jmp    80104ba7 <argstr+0x57>
80104b96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b9d:	8d 76 00             	lea    0x0(%esi),%esi
80104ba0:	83 c0 01             	add    $0x1,%eax
80104ba3:	39 c2                	cmp    %eax,%edx
80104ba5:	76 11                	jbe    80104bb8 <argstr+0x68>
    if(*s == 0)
80104ba7:	80 38 00             	cmpb   $0x0,(%eax)
80104baa:	75 f4                	jne    80104ba0 <argstr+0x50>
      return s - *pp;
80104bac:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104bae:	5b                   	pop    %ebx
80104baf:	5e                   	pop    %esi
80104bb0:	5d                   	pop    %ebp
80104bb1:	c3                   	ret    
80104bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bb8:	5b                   	pop    %ebx
    return -1;
80104bb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bbe:	5e                   	pop    %esi
80104bbf:	5d                   	pop    %ebp
80104bc0:	c3                   	ret    
80104bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bcf:	90                   	nop

80104bd0 <syscall>:
[SYS_getwmapinfo] sys_getwmapinfo
};

void
syscall(void)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	53                   	push   %ebx
80104bd4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104bd7:	e8 e4 ed ff ff       	call   801039c0 <myproc>
80104bdc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104bde:	8b 40 18             	mov    0x18(%eax),%eax
80104be1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104be4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104be7:	83 fa 18             	cmp    $0x18,%edx
80104bea:	77 24                	ja     80104c10 <syscall+0x40>
80104bec:	8b 14 85 40 81 10 80 	mov    -0x7fef7ec0(,%eax,4),%edx
80104bf3:	85 d2                	test   %edx,%edx
80104bf5:	74 19                	je     80104c10 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104bf7:	ff d2                	call   *%edx
80104bf9:	89 c2                	mov    %eax,%edx
80104bfb:	8b 43 18             	mov    0x18(%ebx),%eax
80104bfe:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c04:	c9                   	leave  
80104c05:	c3                   	ret    
80104c06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c0d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104c10:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104c11:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104c14:	50                   	push   %eax
80104c15:	ff 73 10             	push   0x10(%ebx)
80104c18:	68 1d 81 10 80       	push   $0x8010811d
80104c1d:	e8 7e ba ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104c22:	8b 43 18             	mov    0x18(%ebx),%eax
80104c25:	83 c4 10             	add    $0x10,%esp
80104c28:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104c2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c32:	c9                   	leave  
80104c33:	c3                   	ret    
80104c34:	66 90                	xchg   %ax,%ax
80104c36:	66 90                	xchg   %ax,%ax
80104c38:	66 90                	xchg   %ax,%ax
80104c3a:	66 90                	xchg   %ax,%ax
80104c3c:	66 90                	xchg   %ax,%ax
80104c3e:	66 90                	xchg   %ax,%ax

80104c40 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	57                   	push   %edi
80104c44:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104c45:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104c48:	53                   	push   %ebx
80104c49:	83 ec 34             	sub    $0x34,%esp
80104c4c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104c4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104c52:	57                   	push   %edi
80104c53:	50                   	push   %eax
{
80104c54:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104c57:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104c5a:	e8 71 d4 ff ff       	call   801020d0 <nameiparent>
80104c5f:	83 c4 10             	add    $0x10,%esp
80104c62:	85 c0                	test   %eax,%eax
80104c64:	0f 84 46 01 00 00    	je     80104db0 <create+0x170>
    return 0;
  ilock(dp);
80104c6a:	83 ec 0c             	sub    $0xc,%esp
80104c6d:	89 c3                	mov    %eax,%ebx
80104c6f:	50                   	push   %eax
80104c70:	e8 1b cb ff ff       	call   80101790 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104c75:	83 c4 0c             	add    $0xc,%esp
80104c78:	6a 00                	push   $0x0
80104c7a:	57                   	push   %edi
80104c7b:	53                   	push   %ebx
80104c7c:	e8 6f d0 ff ff       	call   80101cf0 <dirlookup>
80104c81:	83 c4 10             	add    $0x10,%esp
80104c84:	89 c6                	mov    %eax,%esi
80104c86:	85 c0                	test   %eax,%eax
80104c88:	74 56                	je     80104ce0 <create+0xa0>
    iunlockput(dp);
80104c8a:	83 ec 0c             	sub    $0xc,%esp
80104c8d:	53                   	push   %ebx
80104c8e:	e8 8d cd ff ff       	call   80101a20 <iunlockput>
    ilock(ip);
80104c93:	89 34 24             	mov    %esi,(%esp)
80104c96:	e8 f5 ca ff ff       	call   80101790 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104c9b:	83 c4 10             	add    $0x10,%esp
80104c9e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104ca3:	75 1b                	jne    80104cc0 <create+0x80>
80104ca5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104caa:	75 14                	jne    80104cc0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104cac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104caf:	89 f0                	mov    %esi,%eax
80104cb1:	5b                   	pop    %ebx
80104cb2:	5e                   	pop    %esi
80104cb3:	5f                   	pop    %edi
80104cb4:	5d                   	pop    %ebp
80104cb5:	c3                   	ret    
80104cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cbd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104cc0:	83 ec 0c             	sub    $0xc,%esp
80104cc3:	56                   	push   %esi
    return 0;
80104cc4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104cc6:	e8 55 cd ff ff       	call   80101a20 <iunlockput>
    return 0;
80104ccb:	83 c4 10             	add    $0x10,%esp
}
80104cce:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cd1:	89 f0                	mov    %esi,%eax
80104cd3:	5b                   	pop    %ebx
80104cd4:	5e                   	pop    %esi
80104cd5:	5f                   	pop    %edi
80104cd6:	5d                   	pop    %ebp
80104cd7:	c3                   	ret    
80104cd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cdf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104ce0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104ce4:	83 ec 08             	sub    $0x8,%esp
80104ce7:	50                   	push   %eax
80104ce8:	ff 33                	push   (%ebx)
80104cea:	e8 31 c9 ff ff       	call   80101620 <ialloc>
80104cef:	83 c4 10             	add    $0x10,%esp
80104cf2:	89 c6                	mov    %eax,%esi
80104cf4:	85 c0                	test   %eax,%eax
80104cf6:	0f 84 cd 00 00 00    	je     80104dc9 <create+0x189>
  ilock(ip);
80104cfc:	83 ec 0c             	sub    $0xc,%esp
80104cff:	50                   	push   %eax
80104d00:	e8 8b ca ff ff       	call   80101790 <ilock>
  ip->major = major;
80104d05:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104d09:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104d0d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104d11:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104d15:	b8 01 00 00 00       	mov    $0x1,%eax
80104d1a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104d1e:	89 34 24             	mov    %esi,(%esp)
80104d21:	e8 ba c9 ff ff       	call   801016e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104d26:	83 c4 10             	add    $0x10,%esp
80104d29:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104d2e:	74 30                	je     80104d60 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104d30:	83 ec 04             	sub    $0x4,%esp
80104d33:	ff 76 04             	push   0x4(%esi)
80104d36:	57                   	push   %edi
80104d37:	53                   	push   %ebx
80104d38:	e8 b3 d2 ff ff       	call   80101ff0 <dirlink>
80104d3d:	83 c4 10             	add    $0x10,%esp
80104d40:	85 c0                	test   %eax,%eax
80104d42:	78 78                	js     80104dbc <create+0x17c>
  iunlockput(dp);
80104d44:	83 ec 0c             	sub    $0xc,%esp
80104d47:	53                   	push   %ebx
80104d48:	e8 d3 cc ff ff       	call   80101a20 <iunlockput>
  return ip;
80104d4d:	83 c4 10             	add    $0x10,%esp
}
80104d50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d53:	89 f0                	mov    %esi,%eax
80104d55:	5b                   	pop    %ebx
80104d56:	5e                   	pop    %esi
80104d57:	5f                   	pop    %edi
80104d58:	5d                   	pop    %ebp
80104d59:	c3                   	ret    
80104d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104d60:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104d63:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104d68:	53                   	push   %ebx
80104d69:	e8 72 c9 ff ff       	call   801016e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104d6e:	83 c4 0c             	add    $0xc,%esp
80104d71:	ff 76 04             	push   0x4(%esi)
80104d74:	68 c4 81 10 80       	push   $0x801081c4
80104d79:	56                   	push   %esi
80104d7a:	e8 71 d2 ff ff       	call   80101ff0 <dirlink>
80104d7f:	83 c4 10             	add    $0x10,%esp
80104d82:	85 c0                	test   %eax,%eax
80104d84:	78 18                	js     80104d9e <create+0x15e>
80104d86:	83 ec 04             	sub    $0x4,%esp
80104d89:	ff 73 04             	push   0x4(%ebx)
80104d8c:	68 c3 81 10 80       	push   $0x801081c3
80104d91:	56                   	push   %esi
80104d92:	e8 59 d2 ff ff       	call   80101ff0 <dirlink>
80104d97:	83 c4 10             	add    $0x10,%esp
80104d9a:	85 c0                	test   %eax,%eax
80104d9c:	79 92                	jns    80104d30 <create+0xf0>
      panic("create dots");
80104d9e:	83 ec 0c             	sub    $0xc,%esp
80104da1:	68 b7 81 10 80       	push   $0x801081b7
80104da6:	e8 d5 b5 ff ff       	call   80100380 <panic>
80104dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104daf:	90                   	nop
}
80104db0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104db3:	31 f6                	xor    %esi,%esi
}
80104db5:	5b                   	pop    %ebx
80104db6:	89 f0                	mov    %esi,%eax
80104db8:	5e                   	pop    %esi
80104db9:	5f                   	pop    %edi
80104dba:	5d                   	pop    %ebp
80104dbb:	c3                   	ret    
    panic("create: dirlink");
80104dbc:	83 ec 0c             	sub    $0xc,%esp
80104dbf:	68 c6 81 10 80       	push   $0x801081c6
80104dc4:	e8 b7 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104dc9:	83 ec 0c             	sub    $0xc,%esp
80104dcc:	68 a8 81 10 80       	push   $0x801081a8
80104dd1:	e8 aa b5 ff ff       	call   80100380 <panic>
80104dd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ddd:	8d 76 00             	lea    0x0(%esi),%esi

80104de0 <sys_dup>:
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	56                   	push   %esi
80104de4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104de5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104de8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104deb:	50                   	push   %eax
80104dec:	6a 00                	push   $0x0
80104dee:	e8 9d fc ff ff       	call   80104a90 <argint>
80104df3:	83 c4 10             	add    $0x10,%esp
80104df6:	85 c0                	test   %eax,%eax
80104df8:	78 36                	js     80104e30 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dfa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104dfe:	77 30                	ja     80104e30 <sys_dup+0x50>
80104e00:	e8 bb eb ff ff       	call   801039c0 <myproc>
80104e05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e08:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e0c:	85 f6                	test   %esi,%esi
80104e0e:	74 20                	je     80104e30 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104e10:	e8 ab eb ff ff       	call   801039c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104e15:	31 db                	xor    %ebx,%ebx
80104e17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104e20:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104e24:	85 d2                	test   %edx,%edx
80104e26:	74 18                	je     80104e40 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104e28:	83 c3 01             	add    $0x1,%ebx
80104e2b:	83 fb 10             	cmp    $0x10,%ebx
80104e2e:	75 f0                	jne    80104e20 <sys_dup+0x40>
}
80104e30:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104e33:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e38:	89 d8                	mov    %ebx,%eax
80104e3a:	5b                   	pop    %ebx
80104e3b:	5e                   	pop    %esi
80104e3c:	5d                   	pop    %ebp
80104e3d:	c3                   	ret    
80104e3e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104e40:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104e43:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104e47:	56                   	push   %esi
80104e48:	e8 63 c0 ff ff       	call   80100eb0 <filedup>
  return fd;
80104e4d:	83 c4 10             	add    $0x10,%esp
}
80104e50:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e53:	89 d8                	mov    %ebx,%eax
80104e55:	5b                   	pop    %ebx
80104e56:	5e                   	pop    %esi
80104e57:	5d                   	pop    %ebp
80104e58:	c3                   	ret    
80104e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e60 <sys_read>:
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	56                   	push   %esi
80104e64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e65:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104e68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e6b:	53                   	push   %ebx
80104e6c:	6a 00                	push   $0x0
80104e6e:	e8 1d fc ff ff       	call   80104a90 <argint>
80104e73:	83 c4 10             	add    $0x10,%esp
80104e76:	85 c0                	test   %eax,%eax
80104e78:	78 5e                	js     80104ed8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e7e:	77 58                	ja     80104ed8 <sys_read+0x78>
80104e80:	e8 3b eb ff ff       	call   801039c0 <myproc>
80104e85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e88:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e8c:	85 f6                	test   %esi,%esi
80104e8e:	74 48                	je     80104ed8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e90:	83 ec 08             	sub    $0x8,%esp
80104e93:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e96:	50                   	push   %eax
80104e97:	6a 02                	push   $0x2
80104e99:	e8 f2 fb ff ff       	call   80104a90 <argint>
80104e9e:	83 c4 10             	add    $0x10,%esp
80104ea1:	85 c0                	test   %eax,%eax
80104ea3:	78 33                	js     80104ed8 <sys_read+0x78>
80104ea5:	83 ec 04             	sub    $0x4,%esp
80104ea8:	ff 75 f0             	push   -0x10(%ebp)
80104eab:	53                   	push   %ebx
80104eac:	6a 01                	push   $0x1
80104eae:	e8 2d fc ff ff       	call   80104ae0 <argptr>
80104eb3:	83 c4 10             	add    $0x10,%esp
80104eb6:	85 c0                	test   %eax,%eax
80104eb8:	78 1e                	js     80104ed8 <sys_read+0x78>
  return fileread(f, p, n);
80104eba:	83 ec 04             	sub    $0x4,%esp
80104ebd:	ff 75 f0             	push   -0x10(%ebp)
80104ec0:	ff 75 f4             	push   -0xc(%ebp)
80104ec3:	56                   	push   %esi
80104ec4:	e8 67 c1 ff ff       	call   80101030 <fileread>
80104ec9:	83 c4 10             	add    $0x10,%esp
}
80104ecc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ecf:	5b                   	pop    %ebx
80104ed0:	5e                   	pop    %esi
80104ed1:	5d                   	pop    %ebp
80104ed2:	c3                   	ret    
80104ed3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ed7:	90                   	nop
    return -1;
80104ed8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104edd:	eb ed                	jmp    80104ecc <sys_read+0x6c>
80104edf:	90                   	nop

80104ee0 <sys_write>:
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	56                   	push   %esi
80104ee4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ee5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ee8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104eeb:	53                   	push   %ebx
80104eec:	6a 00                	push   $0x0
80104eee:	e8 9d fb ff ff       	call   80104a90 <argint>
80104ef3:	83 c4 10             	add    $0x10,%esp
80104ef6:	85 c0                	test   %eax,%eax
80104ef8:	78 5e                	js     80104f58 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104efa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104efe:	77 58                	ja     80104f58 <sys_write+0x78>
80104f00:	e8 bb ea ff ff       	call   801039c0 <myproc>
80104f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f08:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f0c:	85 f6                	test   %esi,%esi
80104f0e:	74 48                	je     80104f58 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f10:	83 ec 08             	sub    $0x8,%esp
80104f13:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f16:	50                   	push   %eax
80104f17:	6a 02                	push   $0x2
80104f19:	e8 72 fb ff ff       	call   80104a90 <argint>
80104f1e:	83 c4 10             	add    $0x10,%esp
80104f21:	85 c0                	test   %eax,%eax
80104f23:	78 33                	js     80104f58 <sys_write+0x78>
80104f25:	83 ec 04             	sub    $0x4,%esp
80104f28:	ff 75 f0             	push   -0x10(%ebp)
80104f2b:	53                   	push   %ebx
80104f2c:	6a 01                	push   $0x1
80104f2e:	e8 ad fb ff ff       	call   80104ae0 <argptr>
80104f33:	83 c4 10             	add    $0x10,%esp
80104f36:	85 c0                	test   %eax,%eax
80104f38:	78 1e                	js     80104f58 <sys_write+0x78>
  return filewrite(f, p, n);
80104f3a:	83 ec 04             	sub    $0x4,%esp
80104f3d:	ff 75 f0             	push   -0x10(%ebp)
80104f40:	ff 75 f4             	push   -0xc(%ebp)
80104f43:	56                   	push   %esi
80104f44:	e8 77 c1 ff ff       	call   801010c0 <filewrite>
80104f49:	83 c4 10             	add    $0x10,%esp
}
80104f4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f4f:	5b                   	pop    %ebx
80104f50:	5e                   	pop    %esi
80104f51:	5d                   	pop    %ebp
80104f52:	c3                   	ret    
80104f53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f57:	90                   	nop
    return -1;
80104f58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f5d:	eb ed                	jmp    80104f4c <sys_write+0x6c>
80104f5f:	90                   	nop

80104f60 <sys_close>:
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	56                   	push   %esi
80104f64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f65:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f6b:	50                   	push   %eax
80104f6c:	6a 00                	push   $0x0
80104f6e:	e8 1d fb ff ff       	call   80104a90 <argint>
80104f73:	83 c4 10             	add    $0x10,%esp
80104f76:	85 c0                	test   %eax,%eax
80104f78:	78 3e                	js     80104fb8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f7e:	77 38                	ja     80104fb8 <sys_close+0x58>
80104f80:	e8 3b ea ff ff       	call   801039c0 <myproc>
80104f85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f88:	8d 5a 08             	lea    0x8(%edx),%ebx
80104f8b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104f8f:	85 f6                	test   %esi,%esi
80104f91:	74 25                	je     80104fb8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104f93:	e8 28 ea ff ff       	call   801039c0 <myproc>
  fileclose(f);
80104f98:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104f9b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104fa2:	00 
  fileclose(f);
80104fa3:	56                   	push   %esi
80104fa4:	e8 57 bf ff ff       	call   80100f00 <fileclose>
  return 0;
80104fa9:	83 c4 10             	add    $0x10,%esp
80104fac:	31 c0                	xor    %eax,%eax
}
80104fae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fb1:	5b                   	pop    %ebx
80104fb2:	5e                   	pop    %esi
80104fb3:	5d                   	pop    %ebp
80104fb4:	c3                   	ret    
80104fb5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104fb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fbd:	eb ef                	jmp    80104fae <sys_close+0x4e>
80104fbf:	90                   	nop

80104fc0 <sys_fstat>:
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	56                   	push   %esi
80104fc4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fc5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fc8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fcb:	53                   	push   %ebx
80104fcc:	6a 00                	push   $0x0
80104fce:	e8 bd fa ff ff       	call   80104a90 <argint>
80104fd3:	83 c4 10             	add    $0x10,%esp
80104fd6:	85 c0                	test   %eax,%eax
80104fd8:	78 46                	js     80105020 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fda:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fde:	77 40                	ja     80105020 <sys_fstat+0x60>
80104fe0:	e8 db e9 ff ff       	call   801039c0 <myproc>
80104fe5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fe8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fec:	85 f6                	test   %esi,%esi
80104fee:	74 30                	je     80105020 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ff0:	83 ec 04             	sub    $0x4,%esp
80104ff3:	6a 14                	push   $0x14
80104ff5:	53                   	push   %ebx
80104ff6:	6a 01                	push   $0x1
80104ff8:	e8 e3 fa ff ff       	call   80104ae0 <argptr>
80104ffd:	83 c4 10             	add    $0x10,%esp
80105000:	85 c0                	test   %eax,%eax
80105002:	78 1c                	js     80105020 <sys_fstat+0x60>
  return filestat(f, st);
80105004:	83 ec 08             	sub    $0x8,%esp
80105007:	ff 75 f4             	push   -0xc(%ebp)
8010500a:	56                   	push   %esi
8010500b:	e8 d0 bf ff ff       	call   80100fe0 <filestat>
80105010:	83 c4 10             	add    $0x10,%esp
}
80105013:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105016:	5b                   	pop    %ebx
80105017:	5e                   	pop    %esi
80105018:	5d                   	pop    %ebp
80105019:	c3                   	ret    
8010501a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105025:	eb ec                	jmp    80105013 <sys_fstat+0x53>
80105027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010502e:	66 90                	xchg   %ax,%ax

80105030 <sys_link>:
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	57                   	push   %edi
80105034:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105035:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105038:	53                   	push   %ebx
80105039:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010503c:	50                   	push   %eax
8010503d:	6a 00                	push   $0x0
8010503f:	e8 0c fb ff ff       	call   80104b50 <argstr>
80105044:	83 c4 10             	add    $0x10,%esp
80105047:	85 c0                	test   %eax,%eax
80105049:	0f 88 fb 00 00 00    	js     8010514a <sys_link+0x11a>
8010504f:	83 ec 08             	sub    $0x8,%esp
80105052:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105055:	50                   	push   %eax
80105056:	6a 01                	push   $0x1
80105058:	e8 f3 fa ff ff       	call   80104b50 <argstr>
8010505d:	83 c4 10             	add    $0x10,%esp
80105060:	85 c0                	test   %eax,%eax
80105062:	0f 88 e2 00 00 00    	js     8010514a <sys_link+0x11a>
  begin_op();
80105068:	e8 23 dd ff ff       	call   80102d90 <begin_op>
  if((ip = namei(old)) == 0){
8010506d:	83 ec 0c             	sub    $0xc,%esp
80105070:	ff 75 d4             	push   -0x2c(%ebp)
80105073:	e8 38 d0 ff ff       	call   801020b0 <namei>
80105078:	83 c4 10             	add    $0x10,%esp
8010507b:	89 c3                	mov    %eax,%ebx
8010507d:	85 c0                	test   %eax,%eax
8010507f:	0f 84 e4 00 00 00    	je     80105169 <sys_link+0x139>
  ilock(ip);
80105085:	83 ec 0c             	sub    $0xc,%esp
80105088:	50                   	push   %eax
80105089:	e8 02 c7 ff ff       	call   80101790 <ilock>
  if(ip->type == T_DIR){
8010508e:	83 c4 10             	add    $0x10,%esp
80105091:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105096:	0f 84 b5 00 00 00    	je     80105151 <sys_link+0x121>
  iupdate(ip);
8010509c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010509f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801050a4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801050a7:	53                   	push   %ebx
801050a8:	e8 33 c6 ff ff       	call   801016e0 <iupdate>
  iunlock(ip);
801050ad:	89 1c 24             	mov    %ebx,(%esp)
801050b0:	e8 bb c7 ff ff       	call   80101870 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801050b5:	58                   	pop    %eax
801050b6:	5a                   	pop    %edx
801050b7:	57                   	push   %edi
801050b8:	ff 75 d0             	push   -0x30(%ebp)
801050bb:	e8 10 d0 ff ff       	call   801020d0 <nameiparent>
801050c0:	83 c4 10             	add    $0x10,%esp
801050c3:	89 c6                	mov    %eax,%esi
801050c5:	85 c0                	test   %eax,%eax
801050c7:	74 5b                	je     80105124 <sys_link+0xf4>
  ilock(dp);
801050c9:	83 ec 0c             	sub    $0xc,%esp
801050cc:	50                   	push   %eax
801050cd:	e8 be c6 ff ff       	call   80101790 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801050d2:	8b 03                	mov    (%ebx),%eax
801050d4:	83 c4 10             	add    $0x10,%esp
801050d7:	39 06                	cmp    %eax,(%esi)
801050d9:	75 3d                	jne    80105118 <sys_link+0xe8>
801050db:	83 ec 04             	sub    $0x4,%esp
801050de:	ff 73 04             	push   0x4(%ebx)
801050e1:	57                   	push   %edi
801050e2:	56                   	push   %esi
801050e3:	e8 08 cf ff ff       	call   80101ff0 <dirlink>
801050e8:	83 c4 10             	add    $0x10,%esp
801050eb:	85 c0                	test   %eax,%eax
801050ed:	78 29                	js     80105118 <sys_link+0xe8>
  iunlockput(dp);
801050ef:	83 ec 0c             	sub    $0xc,%esp
801050f2:	56                   	push   %esi
801050f3:	e8 28 c9 ff ff       	call   80101a20 <iunlockput>
  iput(ip);
801050f8:	89 1c 24             	mov    %ebx,(%esp)
801050fb:	e8 c0 c7 ff ff       	call   801018c0 <iput>
  end_op();
80105100:	e8 fb dc ff ff       	call   80102e00 <end_op>
  return 0;
80105105:	83 c4 10             	add    $0x10,%esp
80105108:	31 c0                	xor    %eax,%eax
}
8010510a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010510d:	5b                   	pop    %ebx
8010510e:	5e                   	pop    %esi
8010510f:	5f                   	pop    %edi
80105110:	5d                   	pop    %ebp
80105111:	c3                   	ret    
80105112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105118:	83 ec 0c             	sub    $0xc,%esp
8010511b:	56                   	push   %esi
8010511c:	e8 ff c8 ff ff       	call   80101a20 <iunlockput>
    goto bad;
80105121:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105124:	83 ec 0c             	sub    $0xc,%esp
80105127:	53                   	push   %ebx
80105128:	e8 63 c6 ff ff       	call   80101790 <ilock>
  ip->nlink--;
8010512d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105132:	89 1c 24             	mov    %ebx,(%esp)
80105135:	e8 a6 c5 ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
8010513a:	89 1c 24             	mov    %ebx,(%esp)
8010513d:	e8 de c8 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105142:	e8 b9 dc ff ff       	call   80102e00 <end_op>
  return -1;
80105147:	83 c4 10             	add    $0x10,%esp
8010514a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010514f:	eb b9                	jmp    8010510a <sys_link+0xda>
    iunlockput(ip);
80105151:	83 ec 0c             	sub    $0xc,%esp
80105154:	53                   	push   %ebx
80105155:	e8 c6 c8 ff ff       	call   80101a20 <iunlockput>
    end_op();
8010515a:	e8 a1 dc ff ff       	call   80102e00 <end_op>
    return -1;
8010515f:	83 c4 10             	add    $0x10,%esp
80105162:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105167:	eb a1                	jmp    8010510a <sys_link+0xda>
    end_op();
80105169:	e8 92 dc ff ff       	call   80102e00 <end_op>
    return -1;
8010516e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105173:	eb 95                	jmp    8010510a <sys_link+0xda>
80105175:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010517c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105180 <sys_unlink>:
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	57                   	push   %edi
80105184:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105185:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105188:	53                   	push   %ebx
80105189:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010518c:	50                   	push   %eax
8010518d:	6a 00                	push   $0x0
8010518f:	e8 bc f9 ff ff       	call   80104b50 <argstr>
80105194:	83 c4 10             	add    $0x10,%esp
80105197:	85 c0                	test   %eax,%eax
80105199:	0f 88 7a 01 00 00    	js     80105319 <sys_unlink+0x199>
  begin_op();
8010519f:	e8 ec db ff ff       	call   80102d90 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801051a4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801051a7:	83 ec 08             	sub    $0x8,%esp
801051aa:	53                   	push   %ebx
801051ab:	ff 75 c0             	push   -0x40(%ebp)
801051ae:	e8 1d cf ff ff       	call   801020d0 <nameiparent>
801051b3:	83 c4 10             	add    $0x10,%esp
801051b6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801051b9:	85 c0                	test   %eax,%eax
801051bb:	0f 84 62 01 00 00    	je     80105323 <sys_unlink+0x1a3>
  ilock(dp);
801051c1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801051c4:	83 ec 0c             	sub    $0xc,%esp
801051c7:	57                   	push   %edi
801051c8:	e8 c3 c5 ff ff       	call   80101790 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801051cd:	58                   	pop    %eax
801051ce:	5a                   	pop    %edx
801051cf:	68 c4 81 10 80       	push   $0x801081c4
801051d4:	53                   	push   %ebx
801051d5:	e8 f6 ca ff ff       	call   80101cd0 <namecmp>
801051da:	83 c4 10             	add    $0x10,%esp
801051dd:	85 c0                	test   %eax,%eax
801051df:	0f 84 fb 00 00 00    	je     801052e0 <sys_unlink+0x160>
801051e5:	83 ec 08             	sub    $0x8,%esp
801051e8:	68 c3 81 10 80       	push   $0x801081c3
801051ed:	53                   	push   %ebx
801051ee:	e8 dd ca ff ff       	call   80101cd0 <namecmp>
801051f3:	83 c4 10             	add    $0x10,%esp
801051f6:	85 c0                	test   %eax,%eax
801051f8:	0f 84 e2 00 00 00    	je     801052e0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801051fe:	83 ec 04             	sub    $0x4,%esp
80105201:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105204:	50                   	push   %eax
80105205:	53                   	push   %ebx
80105206:	57                   	push   %edi
80105207:	e8 e4 ca ff ff       	call   80101cf0 <dirlookup>
8010520c:	83 c4 10             	add    $0x10,%esp
8010520f:	89 c3                	mov    %eax,%ebx
80105211:	85 c0                	test   %eax,%eax
80105213:	0f 84 c7 00 00 00    	je     801052e0 <sys_unlink+0x160>
  ilock(ip);
80105219:	83 ec 0c             	sub    $0xc,%esp
8010521c:	50                   	push   %eax
8010521d:	e8 6e c5 ff ff       	call   80101790 <ilock>
  if(ip->nlink < 1)
80105222:	83 c4 10             	add    $0x10,%esp
80105225:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010522a:	0f 8e 1c 01 00 00    	jle    8010534c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105230:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105235:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105238:	74 66                	je     801052a0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010523a:	83 ec 04             	sub    $0x4,%esp
8010523d:	6a 10                	push   $0x10
8010523f:	6a 00                	push   $0x0
80105241:	57                   	push   %edi
80105242:	e8 89 f5 ff ff       	call   801047d0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105247:	6a 10                	push   $0x10
80105249:	ff 75 c4             	push   -0x3c(%ebp)
8010524c:	57                   	push   %edi
8010524d:	ff 75 b4             	push   -0x4c(%ebp)
80105250:	e8 4b c9 ff ff       	call   80101ba0 <writei>
80105255:	83 c4 20             	add    $0x20,%esp
80105258:	83 f8 10             	cmp    $0x10,%eax
8010525b:	0f 85 de 00 00 00    	jne    8010533f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105261:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105266:	0f 84 94 00 00 00    	je     80105300 <sys_unlink+0x180>
  iunlockput(dp);
8010526c:	83 ec 0c             	sub    $0xc,%esp
8010526f:	ff 75 b4             	push   -0x4c(%ebp)
80105272:	e8 a9 c7 ff ff       	call   80101a20 <iunlockput>
  ip->nlink--;
80105277:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010527c:	89 1c 24             	mov    %ebx,(%esp)
8010527f:	e8 5c c4 ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
80105284:	89 1c 24             	mov    %ebx,(%esp)
80105287:	e8 94 c7 ff ff       	call   80101a20 <iunlockput>
  end_op();
8010528c:	e8 6f db ff ff       	call   80102e00 <end_op>
  return 0;
80105291:	83 c4 10             	add    $0x10,%esp
80105294:	31 c0                	xor    %eax,%eax
}
80105296:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105299:	5b                   	pop    %ebx
8010529a:	5e                   	pop    %esi
8010529b:	5f                   	pop    %edi
8010529c:	5d                   	pop    %ebp
8010529d:	c3                   	ret    
8010529e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801052a0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801052a4:	76 94                	jbe    8010523a <sys_unlink+0xba>
801052a6:	be 20 00 00 00       	mov    $0x20,%esi
801052ab:	eb 0b                	jmp    801052b8 <sys_unlink+0x138>
801052ad:	8d 76 00             	lea    0x0(%esi),%esi
801052b0:	83 c6 10             	add    $0x10,%esi
801052b3:	3b 73 58             	cmp    0x58(%ebx),%esi
801052b6:	73 82                	jae    8010523a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052b8:	6a 10                	push   $0x10
801052ba:	56                   	push   %esi
801052bb:	57                   	push   %edi
801052bc:	53                   	push   %ebx
801052bd:	e8 de c7 ff ff       	call   80101aa0 <readi>
801052c2:	83 c4 10             	add    $0x10,%esp
801052c5:	83 f8 10             	cmp    $0x10,%eax
801052c8:	75 68                	jne    80105332 <sys_unlink+0x1b2>
    if(de.inum != 0)
801052ca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801052cf:	74 df                	je     801052b0 <sys_unlink+0x130>
    iunlockput(ip);
801052d1:	83 ec 0c             	sub    $0xc,%esp
801052d4:	53                   	push   %ebx
801052d5:	e8 46 c7 ff ff       	call   80101a20 <iunlockput>
    goto bad;
801052da:	83 c4 10             	add    $0x10,%esp
801052dd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801052e0:	83 ec 0c             	sub    $0xc,%esp
801052e3:	ff 75 b4             	push   -0x4c(%ebp)
801052e6:	e8 35 c7 ff ff       	call   80101a20 <iunlockput>
  end_op();
801052eb:	e8 10 db ff ff       	call   80102e00 <end_op>
  return -1;
801052f0:	83 c4 10             	add    $0x10,%esp
801052f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052f8:	eb 9c                	jmp    80105296 <sys_unlink+0x116>
801052fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105300:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105303:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105306:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010530b:	50                   	push   %eax
8010530c:	e8 cf c3 ff ff       	call   801016e0 <iupdate>
80105311:	83 c4 10             	add    $0x10,%esp
80105314:	e9 53 ff ff ff       	jmp    8010526c <sys_unlink+0xec>
    return -1;
80105319:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010531e:	e9 73 ff ff ff       	jmp    80105296 <sys_unlink+0x116>
    end_op();
80105323:	e8 d8 da ff ff       	call   80102e00 <end_op>
    return -1;
80105328:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010532d:	e9 64 ff ff ff       	jmp    80105296 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105332:	83 ec 0c             	sub    $0xc,%esp
80105335:	68 e8 81 10 80       	push   $0x801081e8
8010533a:	e8 41 b0 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010533f:	83 ec 0c             	sub    $0xc,%esp
80105342:	68 fa 81 10 80       	push   $0x801081fa
80105347:	e8 34 b0 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010534c:	83 ec 0c             	sub    $0xc,%esp
8010534f:	68 d6 81 10 80       	push   $0x801081d6
80105354:	e8 27 b0 ff ff       	call   80100380 <panic>
80105359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105360 <sys_open>:

int
sys_open(void)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	57                   	push   %edi
80105364:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105365:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105368:	53                   	push   %ebx
80105369:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010536c:	50                   	push   %eax
8010536d:	6a 00                	push   $0x0
8010536f:	e8 dc f7 ff ff       	call   80104b50 <argstr>
80105374:	83 c4 10             	add    $0x10,%esp
80105377:	85 c0                	test   %eax,%eax
80105379:	0f 88 8e 00 00 00    	js     8010540d <sys_open+0xad>
8010537f:	83 ec 08             	sub    $0x8,%esp
80105382:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105385:	50                   	push   %eax
80105386:	6a 01                	push   $0x1
80105388:	e8 03 f7 ff ff       	call   80104a90 <argint>
8010538d:	83 c4 10             	add    $0x10,%esp
80105390:	85 c0                	test   %eax,%eax
80105392:	78 79                	js     8010540d <sys_open+0xad>
    return -1;

  begin_op();
80105394:	e8 f7 d9 ff ff       	call   80102d90 <begin_op>

  if(omode & O_CREATE){
80105399:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010539d:	75 79                	jne    80105418 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010539f:	83 ec 0c             	sub    $0xc,%esp
801053a2:	ff 75 e0             	push   -0x20(%ebp)
801053a5:	e8 06 cd ff ff       	call   801020b0 <namei>
801053aa:	83 c4 10             	add    $0x10,%esp
801053ad:	89 c6                	mov    %eax,%esi
801053af:	85 c0                	test   %eax,%eax
801053b1:	0f 84 7e 00 00 00    	je     80105435 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801053b7:	83 ec 0c             	sub    $0xc,%esp
801053ba:	50                   	push   %eax
801053bb:	e8 d0 c3 ff ff       	call   80101790 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801053c0:	83 c4 10             	add    $0x10,%esp
801053c3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801053c8:	0f 84 c2 00 00 00    	je     80105490 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801053ce:	e8 6d ba ff ff       	call   80100e40 <filealloc>
801053d3:	89 c7                	mov    %eax,%edi
801053d5:	85 c0                	test   %eax,%eax
801053d7:	74 23                	je     801053fc <sys_open+0x9c>
  struct proc *curproc = myproc();
801053d9:	e8 e2 e5 ff ff       	call   801039c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801053de:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801053e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801053e4:	85 d2                	test   %edx,%edx
801053e6:	74 60                	je     80105448 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801053e8:	83 c3 01             	add    $0x1,%ebx
801053eb:	83 fb 10             	cmp    $0x10,%ebx
801053ee:	75 f0                	jne    801053e0 <sys_open+0x80>
    if(f)
      fileclose(f);
801053f0:	83 ec 0c             	sub    $0xc,%esp
801053f3:	57                   	push   %edi
801053f4:	e8 07 bb ff ff       	call   80100f00 <fileclose>
801053f9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801053fc:	83 ec 0c             	sub    $0xc,%esp
801053ff:	56                   	push   %esi
80105400:	e8 1b c6 ff ff       	call   80101a20 <iunlockput>
    end_op();
80105405:	e8 f6 d9 ff ff       	call   80102e00 <end_op>
    return -1;
8010540a:	83 c4 10             	add    $0x10,%esp
8010540d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105412:	eb 6d                	jmp    80105481 <sys_open+0x121>
80105414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105418:	83 ec 0c             	sub    $0xc,%esp
8010541b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010541e:	31 c9                	xor    %ecx,%ecx
80105420:	ba 02 00 00 00       	mov    $0x2,%edx
80105425:	6a 00                	push   $0x0
80105427:	e8 14 f8 ff ff       	call   80104c40 <create>
    if(ip == 0){
8010542c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010542f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105431:	85 c0                	test   %eax,%eax
80105433:	75 99                	jne    801053ce <sys_open+0x6e>
      end_op();
80105435:	e8 c6 d9 ff ff       	call   80102e00 <end_op>
      return -1;
8010543a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010543f:	eb 40                	jmp    80105481 <sys_open+0x121>
80105441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105448:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010544b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010544f:	56                   	push   %esi
80105450:	e8 1b c4 ff ff       	call   80101870 <iunlock>
  end_op();
80105455:	e8 a6 d9 ff ff       	call   80102e00 <end_op>

  f->type = FD_INODE;
8010545a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105460:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105463:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105466:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105469:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010546b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105472:	f7 d0                	not    %eax
80105474:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105477:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010547a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010547d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105481:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105484:	89 d8                	mov    %ebx,%eax
80105486:	5b                   	pop    %ebx
80105487:	5e                   	pop    %esi
80105488:	5f                   	pop    %edi
80105489:	5d                   	pop    %ebp
8010548a:	c3                   	ret    
8010548b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010548f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105490:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105493:	85 c9                	test   %ecx,%ecx
80105495:	0f 84 33 ff ff ff    	je     801053ce <sys_open+0x6e>
8010549b:	e9 5c ff ff ff       	jmp    801053fc <sys_open+0x9c>

801054a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801054a6:	e8 e5 d8 ff ff       	call   80102d90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801054ab:	83 ec 08             	sub    $0x8,%esp
801054ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054b1:	50                   	push   %eax
801054b2:	6a 00                	push   $0x0
801054b4:	e8 97 f6 ff ff       	call   80104b50 <argstr>
801054b9:	83 c4 10             	add    $0x10,%esp
801054bc:	85 c0                	test   %eax,%eax
801054be:	78 30                	js     801054f0 <sys_mkdir+0x50>
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054c6:	31 c9                	xor    %ecx,%ecx
801054c8:	ba 01 00 00 00       	mov    $0x1,%edx
801054cd:	6a 00                	push   $0x0
801054cf:	e8 6c f7 ff ff       	call   80104c40 <create>
801054d4:	83 c4 10             	add    $0x10,%esp
801054d7:	85 c0                	test   %eax,%eax
801054d9:	74 15                	je     801054f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801054db:	83 ec 0c             	sub    $0xc,%esp
801054de:	50                   	push   %eax
801054df:	e8 3c c5 ff ff       	call   80101a20 <iunlockput>
  end_op();
801054e4:	e8 17 d9 ff ff       	call   80102e00 <end_op>
  return 0;
801054e9:	83 c4 10             	add    $0x10,%esp
801054ec:	31 c0                	xor    %eax,%eax
}
801054ee:	c9                   	leave  
801054ef:	c3                   	ret    
    end_op();
801054f0:	e8 0b d9 ff ff       	call   80102e00 <end_op>
    return -1;
801054f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054fa:	c9                   	leave  
801054fb:	c3                   	ret    
801054fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105500 <sys_mknod>:

int
sys_mknod(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105506:	e8 85 d8 ff ff       	call   80102d90 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010550b:	83 ec 08             	sub    $0x8,%esp
8010550e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105511:	50                   	push   %eax
80105512:	6a 00                	push   $0x0
80105514:	e8 37 f6 ff ff       	call   80104b50 <argstr>
80105519:	83 c4 10             	add    $0x10,%esp
8010551c:	85 c0                	test   %eax,%eax
8010551e:	78 60                	js     80105580 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105520:	83 ec 08             	sub    $0x8,%esp
80105523:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105526:	50                   	push   %eax
80105527:	6a 01                	push   $0x1
80105529:	e8 62 f5 ff ff       	call   80104a90 <argint>
  if((argstr(0, &path)) < 0 ||
8010552e:	83 c4 10             	add    $0x10,%esp
80105531:	85 c0                	test   %eax,%eax
80105533:	78 4b                	js     80105580 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105535:	83 ec 08             	sub    $0x8,%esp
80105538:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010553b:	50                   	push   %eax
8010553c:	6a 02                	push   $0x2
8010553e:	e8 4d f5 ff ff       	call   80104a90 <argint>
     argint(1, &major) < 0 ||
80105543:	83 c4 10             	add    $0x10,%esp
80105546:	85 c0                	test   %eax,%eax
80105548:	78 36                	js     80105580 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010554a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010554e:	83 ec 0c             	sub    $0xc,%esp
80105551:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105555:	ba 03 00 00 00       	mov    $0x3,%edx
8010555a:	50                   	push   %eax
8010555b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010555e:	e8 dd f6 ff ff       	call   80104c40 <create>
     argint(2, &minor) < 0 ||
80105563:	83 c4 10             	add    $0x10,%esp
80105566:	85 c0                	test   %eax,%eax
80105568:	74 16                	je     80105580 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010556a:	83 ec 0c             	sub    $0xc,%esp
8010556d:	50                   	push   %eax
8010556e:	e8 ad c4 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105573:	e8 88 d8 ff ff       	call   80102e00 <end_op>
  return 0;
80105578:	83 c4 10             	add    $0x10,%esp
8010557b:	31 c0                	xor    %eax,%eax
}
8010557d:	c9                   	leave  
8010557e:	c3                   	ret    
8010557f:	90                   	nop
    end_op();
80105580:	e8 7b d8 ff ff       	call   80102e00 <end_op>
    return -1;
80105585:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010558a:	c9                   	leave  
8010558b:	c3                   	ret    
8010558c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105590 <sys_chdir>:

int
sys_chdir(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	56                   	push   %esi
80105594:	53                   	push   %ebx
80105595:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105598:	e8 23 e4 ff ff       	call   801039c0 <myproc>
8010559d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010559f:	e8 ec d7 ff ff       	call   80102d90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801055a4:	83 ec 08             	sub    $0x8,%esp
801055a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055aa:	50                   	push   %eax
801055ab:	6a 00                	push   $0x0
801055ad:	e8 9e f5 ff ff       	call   80104b50 <argstr>
801055b2:	83 c4 10             	add    $0x10,%esp
801055b5:	85 c0                	test   %eax,%eax
801055b7:	78 77                	js     80105630 <sys_chdir+0xa0>
801055b9:	83 ec 0c             	sub    $0xc,%esp
801055bc:	ff 75 f4             	push   -0xc(%ebp)
801055bf:	e8 ec ca ff ff       	call   801020b0 <namei>
801055c4:	83 c4 10             	add    $0x10,%esp
801055c7:	89 c3                	mov    %eax,%ebx
801055c9:	85 c0                	test   %eax,%eax
801055cb:	74 63                	je     80105630 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801055cd:	83 ec 0c             	sub    $0xc,%esp
801055d0:	50                   	push   %eax
801055d1:	e8 ba c1 ff ff       	call   80101790 <ilock>
  if(ip->type != T_DIR){
801055d6:	83 c4 10             	add    $0x10,%esp
801055d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055de:	75 30                	jne    80105610 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801055e0:	83 ec 0c             	sub    $0xc,%esp
801055e3:	53                   	push   %ebx
801055e4:	e8 87 c2 ff ff       	call   80101870 <iunlock>
  iput(curproc->cwd);
801055e9:	58                   	pop    %eax
801055ea:	ff 76 68             	push   0x68(%esi)
801055ed:	e8 ce c2 ff ff       	call   801018c0 <iput>
  end_op();
801055f2:	e8 09 d8 ff ff       	call   80102e00 <end_op>
  curproc->cwd = ip;
801055f7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801055fa:	83 c4 10             	add    $0x10,%esp
801055fd:	31 c0                	xor    %eax,%eax
}
801055ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105602:	5b                   	pop    %ebx
80105603:	5e                   	pop    %esi
80105604:	5d                   	pop    %ebp
80105605:	c3                   	ret    
80105606:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010560d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105610:	83 ec 0c             	sub    $0xc,%esp
80105613:	53                   	push   %ebx
80105614:	e8 07 c4 ff ff       	call   80101a20 <iunlockput>
    end_op();
80105619:	e8 e2 d7 ff ff       	call   80102e00 <end_op>
    return -1;
8010561e:	83 c4 10             	add    $0x10,%esp
80105621:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105626:	eb d7                	jmp    801055ff <sys_chdir+0x6f>
80105628:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010562f:	90                   	nop
    end_op();
80105630:	e8 cb d7 ff ff       	call   80102e00 <end_op>
    return -1;
80105635:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010563a:	eb c3                	jmp    801055ff <sys_chdir+0x6f>
8010563c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105640 <sys_exec>:

int
sys_exec(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	57                   	push   %edi
80105644:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105645:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010564b:	53                   	push   %ebx
8010564c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105652:	50                   	push   %eax
80105653:	6a 00                	push   $0x0
80105655:	e8 f6 f4 ff ff       	call   80104b50 <argstr>
8010565a:	83 c4 10             	add    $0x10,%esp
8010565d:	85 c0                	test   %eax,%eax
8010565f:	0f 88 87 00 00 00    	js     801056ec <sys_exec+0xac>
80105665:	83 ec 08             	sub    $0x8,%esp
80105668:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010566e:	50                   	push   %eax
8010566f:	6a 01                	push   $0x1
80105671:	e8 1a f4 ff ff       	call   80104a90 <argint>
80105676:	83 c4 10             	add    $0x10,%esp
80105679:	85 c0                	test   %eax,%eax
8010567b:	78 6f                	js     801056ec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010567d:	83 ec 04             	sub    $0x4,%esp
80105680:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105686:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105688:	68 80 00 00 00       	push   $0x80
8010568d:	6a 00                	push   $0x0
8010568f:	56                   	push   %esi
80105690:	e8 3b f1 ff ff       	call   801047d0 <memset>
80105695:	83 c4 10             	add    $0x10,%esp
80105698:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801056a0:	83 ec 08             	sub    $0x8,%esp
801056a3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801056a9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801056b0:	50                   	push   %eax
801056b1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801056b7:	01 f8                	add    %edi,%eax
801056b9:	50                   	push   %eax
801056ba:	e8 41 f3 ff ff       	call   80104a00 <fetchint>
801056bf:	83 c4 10             	add    $0x10,%esp
801056c2:	85 c0                	test   %eax,%eax
801056c4:	78 26                	js     801056ec <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801056c6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801056cc:	85 c0                	test   %eax,%eax
801056ce:	74 30                	je     80105700 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801056d0:	83 ec 08             	sub    $0x8,%esp
801056d3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801056d6:	52                   	push   %edx
801056d7:	50                   	push   %eax
801056d8:	e8 63 f3 ff ff       	call   80104a40 <fetchstr>
801056dd:	83 c4 10             	add    $0x10,%esp
801056e0:	85 c0                	test   %eax,%eax
801056e2:	78 08                	js     801056ec <sys_exec+0xac>
  for(i=0;; i++){
801056e4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801056e7:	83 fb 20             	cmp    $0x20,%ebx
801056ea:	75 b4                	jne    801056a0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801056ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801056ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056f4:	5b                   	pop    %ebx
801056f5:	5e                   	pop    %esi
801056f6:	5f                   	pop    %edi
801056f7:	5d                   	pop    %ebp
801056f8:	c3                   	ret    
801056f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105700:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105707:	00 00 00 00 
  return exec(path, argv);
8010570b:	83 ec 08             	sub    $0x8,%esp
8010570e:	56                   	push   %esi
8010570f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105715:	e8 96 b3 ff ff       	call   80100ab0 <exec>
8010571a:	83 c4 10             	add    $0x10,%esp
}
8010571d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105720:	5b                   	pop    %ebx
80105721:	5e                   	pop    %esi
80105722:	5f                   	pop    %edi
80105723:	5d                   	pop    %ebp
80105724:	c3                   	ret    
80105725:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105730 <sys_pipe>:

int
sys_pipe(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	57                   	push   %edi
80105734:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105735:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105738:	53                   	push   %ebx
80105739:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010573c:	6a 08                	push   $0x8
8010573e:	50                   	push   %eax
8010573f:	6a 00                	push   $0x0
80105741:	e8 9a f3 ff ff       	call   80104ae0 <argptr>
80105746:	83 c4 10             	add    $0x10,%esp
80105749:	85 c0                	test   %eax,%eax
8010574b:	78 4a                	js     80105797 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010574d:	83 ec 08             	sub    $0x8,%esp
80105750:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105753:	50                   	push   %eax
80105754:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105757:	50                   	push   %eax
80105758:	e8 03 dd ff ff       	call   80103460 <pipealloc>
8010575d:	83 c4 10             	add    $0x10,%esp
80105760:	85 c0                	test   %eax,%eax
80105762:	78 33                	js     80105797 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105764:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105767:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105769:	e8 52 e2 ff ff       	call   801039c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010576e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105770:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105774:	85 f6                	test   %esi,%esi
80105776:	74 28                	je     801057a0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105778:	83 c3 01             	add    $0x1,%ebx
8010577b:	83 fb 10             	cmp    $0x10,%ebx
8010577e:	75 f0                	jne    80105770 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105780:	83 ec 0c             	sub    $0xc,%esp
80105783:	ff 75 e0             	push   -0x20(%ebp)
80105786:	e8 75 b7 ff ff       	call   80100f00 <fileclose>
    fileclose(wf);
8010578b:	58                   	pop    %eax
8010578c:	ff 75 e4             	push   -0x1c(%ebp)
8010578f:	e8 6c b7 ff ff       	call   80100f00 <fileclose>
    return -1;
80105794:	83 c4 10             	add    $0x10,%esp
80105797:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010579c:	eb 53                	jmp    801057f1 <sys_pipe+0xc1>
8010579e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801057a0:	8d 73 08             	lea    0x8(%ebx),%esi
801057a3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801057aa:	e8 11 e2 ff ff       	call   801039c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057af:	31 d2                	xor    %edx,%edx
801057b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801057b8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801057bc:	85 c9                	test   %ecx,%ecx
801057be:	74 20                	je     801057e0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801057c0:	83 c2 01             	add    $0x1,%edx
801057c3:	83 fa 10             	cmp    $0x10,%edx
801057c6:	75 f0                	jne    801057b8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801057c8:	e8 f3 e1 ff ff       	call   801039c0 <myproc>
801057cd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801057d4:	00 
801057d5:	eb a9                	jmp    80105780 <sys_pipe+0x50>
801057d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057de:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801057e0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801057e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057e7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801057e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057ec:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801057ef:	31 c0                	xor    %eax,%eax
}
801057f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057f4:	5b                   	pop    %ebx
801057f5:	5e                   	pop    %esi
801057f6:	5f                   	pop    %edi
801057f7:	5d                   	pop    %ebp
801057f8:	c3                   	ret    
801057f9:	66 90                	xchg   %ax,%ax
801057fb:	66 90                	xchg   %ax,%ax
801057fd:	66 90                	xchg   %ax,%ax
801057ff:	90                   	nop

80105800 <sys_fork>:
#include "wmap.h"

int
sys_fork(void)
{
  return fork();
80105800:	e9 5b e3 ff ff       	jmp    80103b60 <fork>
80105805:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010580c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105810 <sys_exit>:
}

int
sys_exit(void)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	83 ec 08             	sub    $0x8,%esp
  exit();
80105816:	e8 c5 e6 ff ff       	call   80103ee0 <exit>
  return 0;  // not reached
}
8010581b:	31 c0                	xor    %eax,%eax
8010581d:	c9                   	leave  
8010581e:	c3                   	ret    
8010581f:	90                   	nop

80105820 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105820:	e9 0b e8 ff ff       	jmp    80104030 <wait>
80105825:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105830 <sys_kill>:
}

int
sys_kill(void)
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105836:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105839:	50                   	push   %eax
8010583a:	6a 00                	push   $0x0
8010583c:	e8 4f f2 ff ff       	call   80104a90 <argint>
80105841:	83 c4 10             	add    $0x10,%esp
80105844:	85 c0                	test   %eax,%eax
80105846:	78 18                	js     80105860 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105848:	83 ec 0c             	sub    $0xc,%esp
8010584b:	ff 75 f4             	push   -0xc(%ebp)
8010584e:	e8 7d ea ff ff       	call   801042d0 <kill>
80105853:	83 c4 10             	add    $0x10,%esp
}
80105856:	c9                   	leave  
80105857:	c3                   	ret    
80105858:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010585f:	90                   	nop
80105860:	c9                   	leave  
    return -1;
80105861:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105866:	c3                   	ret    
80105867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010586e:	66 90                	xchg   %ax,%ax

80105870 <sys_getpid>:

int
sys_getpid(void)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105876:	e8 45 e1 ff ff       	call   801039c0 <myproc>
8010587b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010587e:	c9                   	leave  
8010587f:	c3                   	ret    

80105880 <sys_sbrk>:

int
sys_sbrk(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105884:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105887:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010588a:	50                   	push   %eax
8010588b:	6a 00                	push   $0x0
8010588d:	e8 fe f1 ff ff       	call   80104a90 <argint>
80105892:	83 c4 10             	add    $0x10,%esp
80105895:	85 c0                	test   %eax,%eax
80105897:	78 27                	js     801058c0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105899:	e8 22 e1 ff ff       	call   801039c0 <myproc>
  if(growproc(n) < 0)
8010589e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801058a1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801058a3:	ff 75 f4             	push   -0xc(%ebp)
801058a6:	e8 35 e2 ff ff       	call   80103ae0 <growproc>
801058ab:	83 c4 10             	add    $0x10,%esp
801058ae:	85 c0                	test   %eax,%eax
801058b0:	78 0e                	js     801058c0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801058b2:	89 d8                	mov    %ebx,%eax
801058b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058b7:	c9                   	leave  
801058b8:	c3                   	ret    
801058b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801058c0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058c5:	eb eb                	jmp    801058b2 <sys_sbrk+0x32>
801058c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ce:	66 90                	xchg   %ax,%ax

801058d0 <sys_sleep>:

int
sys_sleep(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801058d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801058d7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801058da:	50                   	push   %eax
801058db:	6a 00                	push   $0x0
801058dd:	e8 ae f1 ff ff       	call   80104a90 <argint>
801058e2:	83 c4 10             	add    $0x10,%esp
801058e5:	85 c0                	test   %eax,%eax
801058e7:	0f 88 8a 00 00 00    	js     80105977 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801058ed:	83 ec 0c             	sub    $0xc,%esp
801058f0:	68 80 9d 19 80       	push   $0x80199d80
801058f5:	e8 16 ee ff ff       	call   80104710 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801058fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801058fd:	8b 1d 60 9d 19 80    	mov    0x80199d60,%ebx
  while(ticks - ticks0 < n){
80105903:	83 c4 10             	add    $0x10,%esp
80105906:	85 d2                	test   %edx,%edx
80105908:	75 27                	jne    80105931 <sys_sleep+0x61>
8010590a:	eb 54                	jmp    80105960 <sys_sleep+0x90>
8010590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105910:	83 ec 08             	sub    $0x8,%esp
80105913:	68 80 9d 19 80       	push   $0x80199d80
80105918:	68 60 9d 19 80       	push   $0x80199d60
8010591d:	e8 8e e8 ff ff       	call   801041b0 <sleep>
  while(ticks - ticks0 < n){
80105922:	a1 60 9d 19 80       	mov    0x80199d60,%eax
80105927:	83 c4 10             	add    $0x10,%esp
8010592a:	29 d8                	sub    %ebx,%eax
8010592c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010592f:	73 2f                	jae    80105960 <sys_sleep+0x90>
    if(myproc()->killed){
80105931:	e8 8a e0 ff ff       	call   801039c0 <myproc>
80105936:	8b 40 24             	mov    0x24(%eax),%eax
80105939:	85 c0                	test   %eax,%eax
8010593b:	74 d3                	je     80105910 <sys_sleep+0x40>
      release(&tickslock);
8010593d:	83 ec 0c             	sub    $0xc,%esp
80105940:	68 80 9d 19 80       	push   $0x80199d80
80105945:	e8 66 ed ff ff       	call   801046b0 <release>
  }
  release(&tickslock);
  return 0;
}
8010594a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010594d:	83 c4 10             	add    $0x10,%esp
80105950:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105955:	c9                   	leave  
80105956:	c3                   	ret    
80105957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105960:	83 ec 0c             	sub    $0xc,%esp
80105963:	68 80 9d 19 80       	push   $0x80199d80
80105968:	e8 43 ed ff ff       	call   801046b0 <release>
  return 0;
8010596d:	83 c4 10             	add    $0x10,%esp
80105970:	31 c0                	xor    %eax,%eax
}
80105972:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105975:	c9                   	leave  
80105976:	c3                   	ret    
    return -1;
80105977:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010597c:	eb f4                	jmp    80105972 <sys_sleep+0xa2>
8010597e:	66 90                	xchg   %ax,%ax

80105980 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	53                   	push   %ebx
80105984:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105987:	68 80 9d 19 80       	push   $0x80199d80
8010598c:	e8 7f ed ff ff       	call   80104710 <acquire>
  xticks = ticks;
80105991:	8b 1d 60 9d 19 80    	mov    0x80199d60,%ebx
  release(&tickslock);
80105997:	c7 04 24 80 9d 19 80 	movl   $0x80199d80,(%esp)
8010599e:	e8 0d ed ff ff       	call   801046b0 <release>
  return xticks;
}
801059a3:	89 d8                	mov    %ebx,%eax
801059a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059a8:	c9                   	leave  
801059a9:	c3                   	ret    
801059aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801059b0 <sys_wmap>:

uint sys_wmap(void) {
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	57                   	push   %edi
801059b4:	56                   	push   %esi
  uint addr;
  int length, flags, fd;
  if(argint(0, (int *)&addr) < 0) return FAILED; // argint failed
801059b5:	8d 45 d8             	lea    -0x28(%ebp),%eax
uint sys_wmap(void) {
801059b8:	53                   	push   %ebx
801059b9:	83 ec 34             	sub    $0x34,%esp
  if(argint(0, (int *)&addr) < 0) return FAILED; // argint failed
801059bc:	50                   	push   %eax
801059bd:	6a 00                	push   $0x0
801059bf:	e8 cc f0 ff ff       	call   80104a90 <argint>
801059c4:	83 c4 10             	add    $0x10,%esp
801059c7:	85 c0                	test   %eax,%eax
801059c9:	0f 88 a1 00 00 00    	js     80105a70 <sys_wmap+0xc0>
  if(argint(1, &length) < 0) return FAILED; // argint failed
801059cf:	83 ec 08             	sub    $0x8,%esp
801059d2:	8d 45 dc             	lea    -0x24(%ebp),%eax
801059d5:	50                   	push   %eax
801059d6:	6a 01                	push   $0x1
801059d8:	e8 b3 f0 ff ff       	call   80104a90 <argint>
801059dd:	83 c4 10             	add    $0x10,%esp
801059e0:	85 c0                	test   %eax,%eax
801059e2:	0f 88 88 00 00 00    	js     80105a70 <sys_wmap+0xc0>
  if(argint(2, &flags) < 0) return FAILED; // argint failed
801059e8:	83 ec 08             	sub    $0x8,%esp
801059eb:	8d 45 e0             	lea    -0x20(%ebp),%eax
801059ee:	50                   	push   %eax
801059ef:	6a 02                	push   $0x2
801059f1:	e8 9a f0 ff ff       	call   80104a90 <argint>
801059f6:	83 c4 10             	add    $0x10,%esp
801059f9:	85 c0                	test   %eax,%eax
801059fb:	78 73                	js     80105a70 <sys_wmap+0xc0>
  if(argint(3, &fd) < 0) return FAILED; // argint failed
801059fd:	83 ec 08             	sub    $0x8,%esp
80105a00:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a03:	50                   	push   %eax
80105a04:	6a 03                	push   $0x3
80105a06:	e8 85 f0 ff ff       	call   80104a90 <argint>
80105a0b:	83 c4 10             	add    $0x10,%esp
80105a0e:	85 c0                	test   %eax,%eax
80105a10:	78 5e                	js     80105a70 <sys_wmap+0xc0>

  // check if length > 0
  if(length <= 0) return FAILED;
80105a12:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a15:	85 d2                	test   %edx,%edx
80105a17:	7e 57                	jle    80105a70 <sys_wmap+0xc0>

  // check if addr is page aligned and within [0x60000000, 0x80000000)
  if(addr % PGSIZE != 0) return FAILED;
80105a19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105a1c:	89 c3                	mov    %eax,%ebx
80105a1e:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80105a24:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
80105a27:	75 47                	jne    80105a70 <sys_wmap+0xc0>
  if((unsigned long long)addr + (unsigned long long)length >= KERNBASE || addr < KERNBASE - (1 << 29)) return FAILED;
80105a29:	89 d7                	mov    %edx,%edi
80105a2b:	89 c1                	mov    %eax,%ecx
80105a2d:	31 db                	xor    %ebx,%ebx
80105a2f:	8b 75 d4             	mov    -0x2c(%ebp),%esi
80105a32:	c1 ff 1f             	sar    $0x1f,%edi
80105a35:	01 d1                	add    %edx,%ecx
80105a37:	11 fb                	adc    %edi,%ebx
80105a39:	bf ff ff ff 7f       	mov    $0x7fffffff,%edi
80105a3e:	39 cf                	cmp    %ecx,%edi
80105a40:	19 de                	sbb    %ebx,%esi
80105a42:	72 2c                	jb     80105a70 <sys_wmap+0xc0>
80105a44:	3d ff ff ff 5f       	cmp    $0x5fffffff,%eax
80105a49:	76 25                	jbe    80105a70 <sys_wmap+0xc0>

  // check if MAP_SHARED and MAP_FIXED are set
  if((flags & MAP_SHARED) == 0 || (flags & MAP_FIXED) == 0) return FAILED;
80105a4b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80105a4e:	89 cb                	mov    %ecx,%ebx
80105a50:	83 e3 0a             	and    $0xa,%ebx
80105a53:	83 fb 0a             	cmp    $0xa,%ebx
80105a56:	75 18                	jne    80105a70 <sys_wmap+0xc0>

  return wmap(addr, length, flags, fd); // call wmap in wmap.c
80105a58:	ff 75 e4             	push   -0x1c(%ebp)
80105a5b:	51                   	push   %ecx
80105a5c:	52                   	push   %edx
80105a5d:	50                   	push   %eax
80105a5e:	e8 8d 1c 00 00       	call   801076f0 <wmap>
80105a63:	83 c4 10             	add    $0x10,%esp
80105a66:	eb 0d                	jmp    80105a75 <sys_wmap+0xc5>
80105a68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a6f:	90                   	nop
  if(argint(0, (int *)&addr) < 0) return FAILED; // argint failed
80105a70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a78:	5b                   	pop    %ebx
80105a79:	5e                   	pop    %esi
80105a7a:	5f                   	pop    %edi
80105a7b:	5d                   	pop    %ebp
80105a7c:	c3                   	ret    
80105a7d:	8d 76 00             	lea    0x0(%esi),%esi

80105a80 <sys_wunmap>:

int sys_wunmap(void) {
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	83 ec 20             	sub    $0x20,%esp
  uint addr;
  if(argint(0, (int *)&addr) < 0) return FAILED; // argint failed
80105a86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a89:	50                   	push   %eax
80105a8a:	6a 00                	push   $0x0
80105a8c:	e8 ff ef ff ff       	call   80104a90 <argint>
80105a91:	83 c4 10             	add    $0x10,%esp
80105a94:	85 c0                	test   %eax,%eax
80105a96:	78 18                	js     80105ab0 <sys_wunmap+0x30>

  // check if adr is page aligned
  if(addr % PGSIZE != 0) return FAILED;
80105a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a9b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80105aa0:	75 0e                	jne    80105ab0 <sys_wunmap+0x30>

  return wunmap(addr); // call wunmap in wmap.c
80105aa2:	83 ec 0c             	sub    $0xc,%esp
80105aa5:	50                   	push   %eax
80105aa6:	e8 85 1d 00 00       	call   80107830 <wunmap>
80105aab:	83 c4 10             	add    $0x10,%esp
}
80105aae:	c9                   	leave  
80105aaf:	c3                   	ret    
80105ab0:	c9                   	leave  
  if(argint(0, (int *)&addr) < 0) return FAILED; // argint failed
80105ab1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ab6:	c3                   	ret    
80105ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105abe:	66 90                	xchg   %ax,%ax

80105ac0 <sys_va2pa>:

uint sys_va2pa(void) {
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	83 ec 20             	sub    $0x20,%esp
  uint va;
  if(argint(0, (int *)&va) < 0) return FAILED; // argint failed
80105ac6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ac9:	50                   	push   %eax
80105aca:	6a 00                	push   $0x0
80105acc:	e8 bf ef ff ff       	call   80104a90 <argint>
80105ad1:	83 c4 10             	add    $0x10,%esp
80105ad4:	89 c2                	mov    %eax,%edx
80105ad6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105adb:	85 d2                	test   %edx,%edx
80105add:	78 0e                	js     80105aed <sys_va2pa+0x2d>
  return va2pa(va);
80105adf:	83 ec 0c             	sub    $0xc,%esp
80105ae2:	ff 75 f4             	push   -0xc(%ebp)
80105ae5:	e8 d6 1e 00 00       	call   801079c0 <va2pa>
80105aea:	83 c4 10             	add    $0x10,%esp
}
80105aed:	c9                   	leave  
80105aee:	c3                   	ret    
80105aef:	90                   	nop

80105af0 <sys_getwmapinfo>:

int sys_getwmapinfo(void) {
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	83 ec 1c             	sub    $0x1c,%esp
  struct wmapinfo *wminfo;
  if(argptr(0, (char **)&wminfo, sizeof(*wminfo)) < 0) return FAILED; // argptr failed
80105af6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105af9:	68 c4 00 00 00       	push   $0xc4
80105afe:	50                   	push   %eax
80105aff:	6a 00                	push   $0x0
80105b01:	e8 da ef ff ff       	call   80104ae0 <argptr>
80105b06:	83 c4 10             	add    $0x10,%esp
80105b09:	85 c0                	test   %eax,%eax
80105b0b:	78 13                	js     80105b20 <sys_getwmapinfo+0x30>
  return getwmapinfo(wminfo);
80105b0d:	83 ec 0c             	sub    $0xc,%esp
80105b10:	ff 75 f4             	push   -0xc(%ebp)
80105b13:	e8 f8 1e 00 00       	call   80107a10 <getwmapinfo>
80105b18:	83 c4 10             	add    $0x10,%esp
}
80105b1b:	c9                   	leave  
80105b1c:	c3                   	ret    
80105b1d:	8d 76 00             	lea    0x0(%esi),%esi
80105b20:	c9                   	leave  
  if(argptr(0, (char **)&wminfo, sizeof(*wminfo)) < 0) return FAILED; // argptr failed
80105b21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b26:	c3                   	ret    

80105b27 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b27:	1e                   	push   %ds
  pushl %es
80105b28:	06                   	push   %es
  pushl %fs
80105b29:	0f a0                	push   %fs
  pushl %gs
80105b2b:	0f a8                	push   %gs
  pushal
80105b2d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b2e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b32:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b34:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b36:	54                   	push   %esp
  call trap
80105b37:	e8 c4 00 00 00       	call   80105c00 <trap>
  addl $4, %esp
80105b3c:	83 c4 04             	add    $0x4,%esp

80105b3f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b3f:	61                   	popa   
  popl %gs
80105b40:	0f a9                	pop    %gs
  popl %fs
80105b42:	0f a1                	pop    %fs
  popl %es
80105b44:	07                   	pop    %es
  popl %ds
80105b45:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105b46:	83 c4 08             	add    $0x8,%esp
  iret
80105b49:	cf                   	iret   
80105b4a:	66 90                	xchg   %ax,%ax
80105b4c:	66 90                	xchg   %ax,%ax
80105b4e:	66 90                	xchg   %ax,%ax

80105b50 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105b50:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105b51:	31 c0                	xor    %eax,%eax
{
80105b53:	89 e5                	mov    %esp,%ebp
80105b55:	83 ec 08             	sub    $0x8,%esp
80105b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b5f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105b60:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105b67:	c7 04 c5 c2 9d 19 80 	movl   $0x8e000008,-0x7fe6623e(,%eax,8)
80105b6e:	08 00 00 8e 
80105b72:	66 89 14 c5 c0 9d 19 	mov    %dx,-0x7fe66240(,%eax,8)
80105b79:	80 
80105b7a:	c1 ea 10             	shr    $0x10,%edx
80105b7d:	66 89 14 c5 c6 9d 19 	mov    %dx,-0x7fe6623a(,%eax,8)
80105b84:	80 
  for(i = 0; i < 256; i++)
80105b85:	83 c0 01             	add    $0x1,%eax
80105b88:	3d 00 01 00 00       	cmp    $0x100,%eax
80105b8d:	75 d1                	jne    80105b60 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105b8f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b92:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105b97:	c7 05 c2 9f 19 80 08 	movl   $0xef000008,0x80199fc2
80105b9e:	00 00 ef 
  initlock(&tickslock, "time");
80105ba1:	68 09 82 10 80       	push   $0x80108209
80105ba6:	68 80 9d 19 80       	push   $0x80199d80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bab:	66 a3 c0 9f 19 80    	mov    %ax,0x80199fc0
80105bb1:	c1 e8 10             	shr    $0x10,%eax
80105bb4:	66 a3 c6 9f 19 80    	mov    %ax,0x80199fc6
  initlock(&tickslock, "time");
80105bba:	e8 81 e9 ff ff       	call   80104540 <initlock>
}
80105bbf:	83 c4 10             	add    $0x10,%esp
80105bc2:	c9                   	leave  
80105bc3:	c3                   	ret    
80105bc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bcf:	90                   	nop

80105bd0 <idtinit>:

void
idtinit(void)
{
80105bd0:	55                   	push   %ebp
  pd[0] = size-1;
80105bd1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105bd6:	89 e5                	mov    %esp,%ebp
80105bd8:	83 ec 10             	sub    $0x10,%esp
80105bdb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105bdf:	b8 c0 9d 19 80       	mov    $0x80199dc0,%eax
80105be4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105be8:	c1 e8 10             	shr    $0x10,%eax
80105beb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105bef:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105bf2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105bf5:	c9                   	leave  
80105bf6:	c3                   	ret    
80105bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bfe:	66 90                	xchg   %ax,%ax

80105c00 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	57                   	push   %edi
80105c04:	56                   	push   %esi
80105c05:	53                   	push   %ebx
80105c06:	83 ec 1c             	sub    $0x1c,%esp
80105c09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105c0c:	8b 43 30             	mov    0x30(%ebx),%eax
80105c0f:	83 f8 40             	cmp    $0x40,%eax
80105c12:	0f 84 38 01 00 00    	je     80105d50 <trap+0x150>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c18:	83 e8 0e             	sub    $0xe,%eax
80105c1b:	83 f8 31             	cmp    $0x31,%eax
80105c1e:	0f 87 8c 00 00 00    	ja     80105cb0 <trap+0xb0>
80105c24:	ff 24 85 e0 82 10 80 	jmp    *-0x7fef7d20(,%eax,4)
80105c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c2f:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105c30:	e8 6b dd ff ff       	call   801039a0 <cpuid>
80105c35:	85 c0                	test   %eax,%eax
80105c37:	0f 84 b3 02 00 00    	je     80105ef0 <trap+0x2f0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105c3d:	e8 fe cc ff ff       	call   80102940 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c42:	e8 79 dd ff ff       	call   801039c0 <myproc>
80105c47:	85 c0                	test   %eax,%eax
80105c49:	74 1d                	je     80105c68 <trap+0x68>
80105c4b:	e8 70 dd ff ff       	call   801039c0 <myproc>
80105c50:	8b 50 24             	mov    0x24(%eax),%edx
80105c53:	85 d2                	test   %edx,%edx
80105c55:	74 11                	je     80105c68 <trap+0x68>
80105c57:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c5b:	83 e0 03             	and    $0x3,%eax
80105c5e:	66 83 f8 03          	cmp    $0x3,%ax
80105c62:	0f 84 28 02 00 00    	je     80105e90 <trap+0x290>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105c68:	e8 53 dd ff ff       	call   801039c0 <myproc>
80105c6d:	85 c0                	test   %eax,%eax
80105c6f:	74 0f                	je     80105c80 <trap+0x80>
80105c71:	e8 4a dd ff ff       	call   801039c0 <myproc>
80105c76:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105c7a:	0f 84 b8 00 00 00    	je     80105d38 <trap+0x138>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c80:	e8 3b dd ff ff       	call   801039c0 <myproc>
80105c85:	85 c0                	test   %eax,%eax
80105c87:	74 1d                	je     80105ca6 <trap+0xa6>
80105c89:	e8 32 dd ff ff       	call   801039c0 <myproc>
80105c8e:	8b 40 24             	mov    0x24(%eax),%eax
80105c91:	85 c0                	test   %eax,%eax
80105c93:	74 11                	je     80105ca6 <trap+0xa6>
80105c95:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c99:	83 e0 03             	and    $0x3,%eax
80105c9c:	66 83 f8 03          	cmp    $0x3,%ax
80105ca0:	0f 84 d7 00 00 00    	je     80105d7d <trap+0x17d>
    exit();
}
80105ca6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ca9:	5b                   	pop    %ebx
80105caa:	5e                   	pop    %esi
80105cab:	5f                   	pop    %edi
80105cac:	5d                   	pop    %ebp
80105cad:	c3                   	ret    
80105cae:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
80105cb0:	e8 0b dd ff ff       	call   801039c0 <myproc>
80105cb5:	85 c0                	test   %eax,%eax
80105cb7:	0f 84 cf 03 00 00    	je     8010608c <trap+0x48c>
80105cbd:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105cc1:	0f 84 c5 03 00 00    	je     8010608c <trap+0x48c>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105cc7:	0f 20 d1             	mov    %cr2,%ecx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cca:	8b 53 38             	mov    0x38(%ebx),%edx
80105ccd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105cd0:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105cd3:	e8 c8 dc ff ff       	call   801039a0 <cpuid>
80105cd8:	8b 73 30             	mov    0x30(%ebx),%esi
80105cdb:	89 c7                	mov    %eax,%edi
80105cdd:	8b 43 34             	mov    0x34(%ebx),%eax
80105ce0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105ce3:	e8 d8 dc ff ff       	call   801039c0 <myproc>
80105ce8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ceb:	e8 d0 dc ff ff       	call   801039c0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cf0:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105cf3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105cf6:	51                   	push   %ecx
80105cf7:	52                   	push   %edx
80105cf8:	57                   	push   %edi
80105cf9:	ff 75 e4             	push   -0x1c(%ebp)
80105cfc:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105cfd:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105d00:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d03:	56                   	push   %esi
80105d04:	ff 70 10             	push   0x10(%eax)
80105d07:	68 9c 82 10 80       	push   $0x8010829c
80105d0c:	e8 8f a9 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105d11:	83 c4 20             	add    $0x20,%esp
80105d14:	e8 a7 dc ff ff       	call   801039c0 <myproc>
80105d19:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d20:	e8 9b dc ff ff       	call   801039c0 <myproc>
80105d25:	85 c0                	test   %eax,%eax
80105d27:	0f 85 1e ff ff ff    	jne    80105c4b <trap+0x4b>
80105d2d:	e9 36 ff ff ff       	jmp    80105c68 <trap+0x68>
80105d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105d38:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105d3c:	0f 85 3e ff ff ff    	jne    80105c80 <trap+0x80>
    yield();
80105d42:	e8 19 e4 ff ff       	call   80104160 <yield>
80105d47:	e9 34 ff ff ff       	jmp    80105c80 <trap+0x80>
80105d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105d50:	e8 6b dc ff ff       	call   801039c0 <myproc>
80105d55:	8b 70 24             	mov    0x24(%eax),%esi
80105d58:	85 f6                	test   %esi,%esi
80105d5a:	0f 85 80 01 00 00    	jne    80105ee0 <trap+0x2e0>
    myproc()->tf = tf;
80105d60:	e8 5b dc ff ff       	call   801039c0 <myproc>
80105d65:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105d68:	e8 63 ee ff ff       	call   80104bd0 <syscall>
    if(myproc()->killed)
80105d6d:	e8 4e dc ff ff       	call   801039c0 <myproc>
80105d72:	8b 58 24             	mov    0x24(%eax),%ebx
80105d75:	85 db                	test   %ebx,%ebx
80105d77:	0f 84 29 ff ff ff    	je     80105ca6 <trap+0xa6>
}
80105d7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d80:	5b                   	pop    %ebx
80105d81:	5e                   	pop    %esi
80105d82:	5f                   	pop    %edi
80105d83:	5d                   	pop    %ebp
      exit();
80105d84:	e9 57 e1 ff ff       	jmp    80103ee0 <exit>
80105d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105d90:	8b 7b 38             	mov    0x38(%ebx),%edi
80105d93:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105d97:	e8 04 dc ff ff       	call   801039a0 <cpuid>
80105d9c:	57                   	push   %edi
80105d9d:	56                   	push   %esi
80105d9e:	50                   	push   %eax
80105d9f:	68 44 82 10 80       	push   $0x80108244
80105da4:	e8 f7 a8 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105da9:	e8 92 cb ff ff       	call   80102940 <lapiceoi>
    break;
80105dae:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105db1:	e8 0a dc ff ff       	call   801039c0 <myproc>
80105db6:	85 c0                	test   %eax,%eax
80105db8:	0f 85 8d fe ff ff    	jne    80105c4b <trap+0x4b>
80105dbe:	e9 a5 fe ff ff       	jmp    80105c68 <trap+0x68>
80105dc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105dc7:	90                   	nop
    kbdintr();
80105dc8:	e8 33 ca ff ff       	call   80102800 <kbdintr>
    lapiceoi();
80105dcd:	e8 6e cb ff ff       	call   80102940 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dd2:	e8 e9 db ff ff       	call   801039c0 <myproc>
80105dd7:	85 c0                	test   %eax,%eax
80105dd9:	0f 85 6c fe ff ff    	jne    80105c4b <trap+0x4b>
80105ddf:	e9 84 fe ff ff       	jmp    80105c68 <trap+0x68>
80105de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105de8:	e8 43 04 00 00       	call   80106230 <uartintr>
    lapiceoi();
80105ded:	e8 4e cb ff ff       	call   80102940 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105df2:	e8 c9 db ff ff       	call   801039c0 <myproc>
80105df7:	85 c0                	test   %eax,%eax
80105df9:	0f 85 4c fe ff ff    	jne    80105c4b <trap+0x4b>
80105dff:	e9 64 fe ff ff       	jmp    80105c68 <trap+0x68>
80105e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105e08:	e8 43 c4 ff ff       	call   80102250 <ideintr>
80105e0d:	e9 2b fe ff ff       	jmp    80105c3d <trap+0x3d>
80105e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105e18:	0f 20 d2             	mov    %cr2,%edx
    if(addr_fault >= KERNBASE) cprintf("addr is too high!\n");
80105e1b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80105e1e:	85 d2                	test   %edx,%edx
80105e20:	0f 88 02 01 00 00    	js     80105f28 <trap+0x328>
    struct proc* proc = myproc();
80105e26:	e8 95 db ff ff       	call   801039c0 <myproc>
    if(addr_fault < KERNBASE - (1 << 29)) { // not in wmap heap range
80105e2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    struct proc* proc = myproc();
80105e2e:	89 c6                	mov    %eax,%esi
    if(addr_fault < KERNBASE - (1 << 29)) { // not in wmap heap range
80105e30:	81 fa ff ff ff 5f    	cmp    $0x5fffffff,%edx
80105e36:	76 68                	jbe    80105ea0 <trap+0x2a0>
    for(int i = 0; i < MAX_WMMAP_INFO; i++) {
80105e38:	31 ff                	xor    %edi,%edi
80105e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(mappings->length[i] > 0) { // a mapping exists
80105e40:	8b 84 be c0 00 00 00 	mov    0xc0(%esi,%edi,4),%eax
80105e47:	85 c0                	test   %eax,%eax
80105e49:	7e 15                	jle    80105e60 <trap+0x260>
        if(addr_fault >= mappings->addr[i] && addr_fault < mappings->addr[i] + mappings->length[i]) { // corresponding mapping found
80105e4b:	8b 8c be 80 00 00 00 	mov    0x80(%esi,%edi,4),%ecx
80105e52:	39 d1                	cmp    %edx,%ecx
80105e54:	77 0a                	ja     80105e60 <trap+0x260>
80105e56:	01 c8                	add    %ecx,%eax
80105e58:	39 d0                	cmp    %edx,%eax
80105e5a:	0f 87 f0 00 00 00    	ja     80105f50 <trap+0x350>
    for(int i = 0; i < MAX_WMMAP_INFO; i++) {
80105e60:	83 c7 01             	add    $0x1,%edi
80105e63:	83 ff 10             	cmp    $0x10,%edi
80105e66:	75 d8                	jne    80105e40 <trap+0x240>
      cprintf("Segmentation Fault\n");
80105e68:	83 ec 0c             	sub    $0xc,%esp
80105e6b:	68 2a 82 10 80       	push   $0x8010822a
80105e70:	e8 2b a8 ff ff       	call   801006a0 <cprintf>
      kill(proc->pid); // kill the process
80105e75:	59                   	pop    %ecx
80105e76:	ff 76 10             	push   0x10(%esi)
80105e79:	e8 52 e4 ff ff       	call   801042d0 <kill>
80105e7e:	83 c4 10             	add    $0x10,%esp
80105e81:	e9 bc fd ff ff       	jmp    80105c42 <trap+0x42>
80105e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e8d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105e90:	e8 4b e0 ff ff       	call   80103ee0 <exit>
80105e95:	e9 ce fd ff ff       	jmp    80105c68 <trap+0x68>
80105e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      pte_t *pte = walkpgdir(proc->pgdir, page_addr, 0); // TODO - check ret val of walkpgdir
80105ea0:	83 ec 04             	sub    $0x4,%esp
      char *page_addr = (char*)PGROUNDDOWN(addr_fault);
80105ea3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
      pte_t *pte = walkpgdir(proc->pgdir, page_addr, 0); // TODO - check ret val of walkpgdir
80105ea9:	6a 00                	push   $0x0
80105eab:	52                   	push   %edx
80105eac:	ff 70 04             	push   0x4(%eax)
80105eaf:	e8 4c 0f 00 00       	call   80106e00 <walkpgdir>
      if(pte == 0 || (*pte & PTE_P) == 0) {
80105eb4:	83 c4 10             	add    $0x10,%esp
      pte_t *pte = walkpgdir(proc->pgdir, page_addr, 0); // TODO - check ret val of walkpgdir
80105eb7:	89 c7                	mov    %eax,%edi
      if(pte == 0 || (*pte & PTE_P) == 0) {
80105eb9:	85 c0                	test   %eax,%eax
80105ebb:	74 0b                	je     80105ec8 <trap+0x2c8>
80105ebd:	8b 10                	mov    (%eax),%edx
80105ebf:	f6 c2 01             	test   $0x1,%dl
80105ec2:	0f 85 f2 00 00 00    	jne    80105fba <trap+0x3ba>
        cprintf("break 1\n");
80105ec8:	83 ec 0c             	sub    $0xc,%esp
80105ecb:	68 21 82 10 80       	push   $0x80108221
80105ed0:	e8 cb a7 ff ff       	call   801006a0 <cprintf>
        break;
80105ed5:	83 c4 10             	add    $0x10,%esp
80105ed8:	e9 65 fd ff ff       	jmp    80105c42 <trap+0x42>
80105edd:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
80105ee0:	e8 fb df ff ff       	call   80103ee0 <exit>
80105ee5:	e9 76 fe ff ff       	jmp    80105d60 <trap+0x160>
80105eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105ef0:	83 ec 0c             	sub    $0xc,%esp
80105ef3:	68 80 9d 19 80       	push   $0x80199d80
80105ef8:	e8 13 e8 ff ff       	call   80104710 <acquire>
      wakeup(&ticks);
80105efd:	c7 04 24 60 9d 19 80 	movl   $0x80199d60,(%esp)
      ticks++;
80105f04:	83 05 60 9d 19 80 01 	addl   $0x1,0x80199d60
      wakeup(&ticks);
80105f0b:	e8 60 e3 ff ff       	call   80104270 <wakeup>
      release(&tickslock);
80105f10:	c7 04 24 80 9d 19 80 	movl   $0x80199d80,(%esp)
80105f17:	e8 94 e7 ff ff       	call   801046b0 <release>
80105f1c:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105f1f:	e9 19 fd ff ff       	jmp    80105c3d <trap+0x3d>
80105f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(addr_fault >= KERNBASE) cprintf("addr is too high!\n");
80105f28:	83 ec 0c             	sub    $0xc,%esp
80105f2b:	68 0e 82 10 80       	push   $0x8010820e
80105f30:	e8 6b a7 ff ff       	call   801006a0 <cprintf>
    struct proc* proc = myproc();
80105f35:	e8 86 da ff ff       	call   801039c0 <myproc>
80105f3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105f3d:	83 c4 10             	add    $0x10,%esp
80105f40:	89 c6                	mov    %eax,%esi
    if(addr_fault < KERNBASE - (1 << 29)) { // not in wmap heap range
80105f42:	e9 f1 fe ff ff       	jmp    80105e38 <trap+0x238>
80105f47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f4e:	66 90                	xchg   %ax,%ax
80105f50:	8d 3c be             	lea    (%esi,%edi,4),%edi
          char *mem = kalloc();
80105f53:	89 55 e0             	mov    %edx,-0x20(%ebp)
80105f56:	e8 55 c7 ff ff       	call   801026b0 <kalloc>
          if((mappings->flags[i] & MAP_ANONYMOUS) != 0) { // not a file-backed mapping
80105f5b:	f6 87 40 01 00 00 04 	testb  $0x4,0x140(%edi)
80105f62:	8b 55 e0             	mov    -0x20(%ebp),%edx
          char *mem = kalloc();
80105f65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          if((mappings->flags[i] & MAP_ANONYMOUS) != 0) { // not a file-backed mapping
80105f68:	0f 84 bd 00 00 00    	je     8010602b <trap+0x42b>
            memset(mem, 0, PGSIZE); // zero out the page
80105f6e:	83 ec 04             	sub    $0x4,%esp
80105f71:	68 00 10 00 00       	push   $0x1000
80105f76:	6a 00                	push   $0x0
80105f78:	50                   	push   %eax
80105f79:	e8 52 e8 ff ff       	call   801047d0 <memset>
80105f7e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105f81:	83 c4 10             	add    $0x10,%esp
          mappages(proc->pgdir, (void *)addr_fault, PGSIZE, V2P(mem), PTE_W | PTE_U); // map page
80105f84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f87:	83 ec 0c             	sub    $0xc,%esp
80105f8a:	6a 06                	push   $0x6
80105f8c:	05 00 00 00 80       	add    $0x80000000,%eax
80105f91:	50                   	push   %eax
80105f92:	68 00 10 00 00       	push   $0x1000
80105f97:	52                   	push   %edx
80105f98:	ff 76 04             	push   0x4(%esi)
80105f9b:	e8 f0 0e 00 00       	call   80106e90 <mappages>
          lcr3(V2P(proc->pgdir)); // tlb flush cr3
80105fa0:	8b 46 04             	mov    0x4(%esi),%eax
80105fa3:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80105fa8:	0f 22 d8             	mov    %eax,%cr3
          mappings->n_loaded_pages[i]++;
80105fab:	83 87 00 01 00 00 01 	addl   $0x1,0x100(%edi)
80105fb2:	83 c4 20             	add    $0x20,%esp
80105fb5:	e9 88 fc ff ff       	jmp    80105c42 <trap+0x42>
      reference_count[physical_addr / PGSIZE]--;
80105fba:	89 d0                	mov    %edx,%eax
80105fbc:	89 55 e0             	mov    %edx,-0x20(%ebp)
80105fbf:	c1 e8 0c             	shr    $0xc,%eax
80105fc2:	80 a8 40 26 11 80 01 	subb   $0x1,-0x7feed9c0(%eax)
      uint flags = PTE_FLAGS(*pte);
80105fc9:	8b 07                	mov    (%edi),%eax
80105fcb:	25 ff 0f 00 00       	and    $0xfff,%eax
80105fd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      char *mem = kalloc();
80105fd3:	e8 d8 c6 ff ff       	call   801026b0 <kalloc>
      uint physical_addr = PTE_ADDR(*pte);
80105fd8:	8b 55 e0             	mov    -0x20(%ebp),%edx
      memmove(mem, (char *)P2V(physical_addr), PGSIZE);
80105fdb:	83 ec 04             	sub    $0x4,%esp
      char *mem = kalloc();
80105fde:	89 c1                	mov    %eax,%ecx
      memmove(mem, (char *)P2V(physical_addr), PGSIZE);
80105fe0:	68 00 10 00 00       	push   $0x1000
      uint physical_addr = PTE_ADDR(*pte);
80105fe5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
      memmove(mem, (char *)P2V(physical_addr), PGSIZE);
80105feb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80105fee:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80105ff4:	50                   	push   %eax
80105ff5:	51                   	push   %ecx
80105ff6:	e8 75 e8 ff ff       	call   80104870 <memmove>
      *pte = V2P(mem) | flags | PTE_W | PTE_P;
80105ffb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80105ffe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106001:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
80106007:	09 c8                	or     %ecx,%eax
80106009:	83 c8 03             	or     $0x3,%eax
8010600c:	89 07                	mov    %eax,(%edi)
      lcr3(V2P(proc->pgdir)); // flush tlb
8010600e:	8b 46 04             	mov    0x4(%esi),%eax
80106011:	05 00 00 00 80       	add    $0x80000000,%eax
80106016:	0f 22 d8             	mov    %eax,%cr3
      reference_count[V2P(mem) / PGSIZE]++;
80106019:	c1 e9 0c             	shr    $0xc,%ecx
      break;
8010601c:	83 c4 10             	add    $0x10,%esp
      reference_count[V2P(mem) / PGSIZE]++;
8010601f:	80 81 40 26 11 80 01 	addb   $0x1,-0x7feed9c0(%ecx)
      break;
80106026:	e9 17 fc ff ff       	jmp    80105c42 <trap+0x42>
            struct file *file = proc->ofile[mappings->fd[i]];
8010602b:	8b 87 80 01 00 00    	mov    0x180(%edi),%eax
            int page_idx = (addr_fault - mappings->addr[i]) / PGSIZE;
80106031:	89 55 d8             	mov    %edx,-0x28(%ebp)
            struct inode *inode = file->ip;
80106034:	8b 44 86 28          	mov    0x28(%esi,%eax,4),%eax
80106038:	8b 40 10             	mov    0x10(%eax),%eax
8010603b:	89 45 e0             	mov    %eax,-0x20(%ebp)
            int page_idx = (addr_fault - mappings->addr[i]) / PGSIZE;
8010603e:	89 d0                	mov    %edx,%eax
80106040:	2b 87 80 00 00 00    	sub    0x80(%edi),%eax
            int offset = page_idx * PGSIZE;
80106046:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010604b:	89 45 dc             	mov    %eax,-0x24(%ebp)
            begin_op();
8010604e:	e8 3d cd ff ff       	call   80102d90 <begin_op>
            ilock(inode);
80106053:	83 ec 0c             	sub    $0xc,%esp
80106056:	ff 75 e0             	push   -0x20(%ebp)
80106059:	e8 32 b7 ff ff       	call   80101790 <ilock>
            readi(inode, mem, offset, PGSIZE);
8010605e:	68 00 10 00 00       	push   $0x1000
80106063:	ff 75 dc             	push   -0x24(%ebp)
80106066:	ff 75 e4             	push   -0x1c(%ebp)
80106069:	ff 75 e0             	push   -0x20(%ebp)
8010606c:	e8 2f ba ff ff       	call   80101aa0 <readi>
            iunlock(inode);
80106071:	83 c4 14             	add    $0x14,%esp
80106074:	ff 75 e0             	push   -0x20(%ebp)
80106077:	e8 f4 b7 ff ff       	call   80101870 <iunlock>
            end_op();
8010607c:	e8 7f cd ff ff       	call   80102e00 <end_op>
80106081:	8b 55 d8             	mov    -0x28(%ebp),%edx
80106084:	83 c4 10             	add    $0x10,%esp
80106087:	e9 f8 fe ff ff       	jmp    80105f84 <trap+0x384>
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010608c:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010608f:	8b 73 38             	mov    0x38(%ebx),%esi
80106092:	e8 09 d9 ff ff       	call   801039a0 <cpuid>
80106097:	83 ec 0c             	sub    $0xc,%esp
8010609a:	57                   	push   %edi
8010609b:	56                   	push   %esi
8010609c:	50                   	push   %eax
8010609d:	ff 73 30             	push   0x30(%ebx)
801060a0:	68 68 82 10 80       	push   $0x80108268
801060a5:	e8 f6 a5 ff ff       	call   801006a0 <cprintf>
      panic("trap");
801060aa:	83 c4 14             	add    $0x14,%esp
801060ad:	68 3e 82 10 80       	push   $0x8010823e
801060b2:	e8 c9 a2 ff ff       	call   80100380 <panic>
801060b7:	66 90                	xchg   %ax,%ax
801060b9:	66 90                	xchg   %ax,%ax
801060bb:	66 90                	xchg   %ax,%ax
801060bd:	66 90                	xchg   %ax,%ax
801060bf:	90                   	nop

801060c0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801060c0:	a1 c0 a5 19 80       	mov    0x8019a5c0,%eax
801060c5:	85 c0                	test   %eax,%eax
801060c7:	74 17                	je     801060e0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060c9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060ce:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801060cf:	a8 01                	test   $0x1,%al
801060d1:	74 0d                	je     801060e0 <uartgetc+0x20>
801060d3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060d8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801060d9:	0f b6 c0             	movzbl %al,%eax
801060dc:	c3                   	ret    
801060dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801060e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060e5:	c3                   	ret    
801060e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ed:	8d 76 00             	lea    0x0(%esi),%esi

801060f0 <uartinit>:
{
801060f0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060f1:	31 c9                	xor    %ecx,%ecx
801060f3:	89 c8                	mov    %ecx,%eax
801060f5:	89 e5                	mov    %esp,%ebp
801060f7:	57                   	push   %edi
801060f8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801060fd:	56                   	push   %esi
801060fe:	89 fa                	mov    %edi,%edx
80106100:	53                   	push   %ebx
80106101:	83 ec 1c             	sub    $0x1c,%esp
80106104:	ee                   	out    %al,(%dx)
80106105:	be fb 03 00 00       	mov    $0x3fb,%esi
8010610a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010610f:	89 f2                	mov    %esi,%edx
80106111:	ee                   	out    %al,(%dx)
80106112:	b8 0c 00 00 00       	mov    $0xc,%eax
80106117:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010611c:	ee                   	out    %al,(%dx)
8010611d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106122:	89 c8                	mov    %ecx,%eax
80106124:	89 da                	mov    %ebx,%edx
80106126:	ee                   	out    %al,(%dx)
80106127:	b8 03 00 00 00       	mov    $0x3,%eax
8010612c:	89 f2                	mov    %esi,%edx
8010612e:	ee                   	out    %al,(%dx)
8010612f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106134:	89 c8                	mov    %ecx,%eax
80106136:	ee                   	out    %al,(%dx)
80106137:	b8 01 00 00 00       	mov    $0x1,%eax
8010613c:	89 da                	mov    %ebx,%edx
8010613e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010613f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106144:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106145:	3c ff                	cmp    $0xff,%al
80106147:	74 78                	je     801061c1 <uartinit+0xd1>
  uart = 1;
80106149:	c7 05 c0 a5 19 80 01 	movl   $0x1,0x8019a5c0
80106150:	00 00 00 
80106153:	89 fa                	mov    %edi,%edx
80106155:	ec                   	in     (%dx),%al
80106156:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010615b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010615c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010615f:	bf a8 83 10 80       	mov    $0x801083a8,%edi
80106164:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106169:	6a 00                	push   $0x0
8010616b:	6a 04                	push   $0x4
8010616d:	e8 1e c3 ff ff       	call   80102490 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106172:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106176:	83 c4 10             	add    $0x10,%esp
80106179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106180:	a1 c0 a5 19 80       	mov    0x8019a5c0,%eax
80106185:	bb 80 00 00 00       	mov    $0x80,%ebx
8010618a:	85 c0                	test   %eax,%eax
8010618c:	75 14                	jne    801061a2 <uartinit+0xb2>
8010618e:	eb 23                	jmp    801061b3 <uartinit+0xc3>
    microdelay(10);
80106190:	83 ec 0c             	sub    $0xc,%esp
80106193:	6a 0a                	push   $0xa
80106195:	e8 c6 c7 ff ff       	call   80102960 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010619a:	83 c4 10             	add    $0x10,%esp
8010619d:	83 eb 01             	sub    $0x1,%ebx
801061a0:	74 07                	je     801061a9 <uartinit+0xb9>
801061a2:	89 f2                	mov    %esi,%edx
801061a4:	ec                   	in     (%dx),%al
801061a5:	a8 20                	test   $0x20,%al
801061a7:	74 e7                	je     80106190 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801061a9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801061ad:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061b2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801061b3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801061b7:	83 c7 01             	add    $0x1,%edi
801061ba:	88 45 e7             	mov    %al,-0x19(%ebp)
801061bd:	84 c0                	test   %al,%al
801061bf:	75 bf                	jne    80106180 <uartinit+0x90>
}
801061c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061c4:	5b                   	pop    %ebx
801061c5:	5e                   	pop    %esi
801061c6:	5f                   	pop    %edi
801061c7:	5d                   	pop    %ebp
801061c8:	c3                   	ret    
801061c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061d0 <uartputc>:
  if(!uart)
801061d0:	a1 c0 a5 19 80       	mov    0x8019a5c0,%eax
801061d5:	85 c0                	test   %eax,%eax
801061d7:	74 47                	je     80106220 <uartputc+0x50>
{
801061d9:	55                   	push   %ebp
801061da:	89 e5                	mov    %esp,%ebp
801061dc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801061dd:	be fd 03 00 00       	mov    $0x3fd,%esi
801061e2:	53                   	push   %ebx
801061e3:	bb 80 00 00 00       	mov    $0x80,%ebx
801061e8:	eb 18                	jmp    80106202 <uartputc+0x32>
801061ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801061f0:	83 ec 0c             	sub    $0xc,%esp
801061f3:	6a 0a                	push   $0xa
801061f5:	e8 66 c7 ff ff       	call   80102960 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801061fa:	83 c4 10             	add    $0x10,%esp
801061fd:	83 eb 01             	sub    $0x1,%ebx
80106200:	74 07                	je     80106209 <uartputc+0x39>
80106202:	89 f2                	mov    %esi,%edx
80106204:	ec                   	in     (%dx),%al
80106205:	a8 20                	test   $0x20,%al
80106207:	74 e7                	je     801061f0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106209:	8b 45 08             	mov    0x8(%ebp),%eax
8010620c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106211:	ee                   	out    %al,(%dx)
}
80106212:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106215:	5b                   	pop    %ebx
80106216:	5e                   	pop    %esi
80106217:	5d                   	pop    %ebp
80106218:	c3                   	ret    
80106219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106220:	c3                   	ret    
80106221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010622f:	90                   	nop

80106230 <uartintr>:

void
uartintr(void)
{
80106230:	55                   	push   %ebp
80106231:	89 e5                	mov    %esp,%ebp
80106233:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106236:	68 c0 60 10 80       	push   $0x801060c0
8010623b:	e8 40 a6 ff ff       	call   80100880 <consoleintr>
}
80106240:	83 c4 10             	add    $0x10,%esp
80106243:	c9                   	leave  
80106244:	c3                   	ret    

80106245 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106245:	6a 00                	push   $0x0
  pushl $0
80106247:	6a 00                	push   $0x0
  jmp alltraps
80106249:	e9 d9 f8 ff ff       	jmp    80105b27 <alltraps>

8010624e <vector1>:
.globl vector1
vector1:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $1
80106250:	6a 01                	push   $0x1
  jmp alltraps
80106252:	e9 d0 f8 ff ff       	jmp    80105b27 <alltraps>

80106257 <vector2>:
.globl vector2
vector2:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $2
80106259:	6a 02                	push   $0x2
  jmp alltraps
8010625b:	e9 c7 f8 ff ff       	jmp    80105b27 <alltraps>

80106260 <vector3>:
.globl vector3
vector3:
  pushl $0
80106260:	6a 00                	push   $0x0
  pushl $3
80106262:	6a 03                	push   $0x3
  jmp alltraps
80106264:	e9 be f8 ff ff       	jmp    80105b27 <alltraps>

80106269 <vector4>:
.globl vector4
vector4:
  pushl $0
80106269:	6a 00                	push   $0x0
  pushl $4
8010626b:	6a 04                	push   $0x4
  jmp alltraps
8010626d:	e9 b5 f8 ff ff       	jmp    80105b27 <alltraps>

80106272 <vector5>:
.globl vector5
vector5:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $5
80106274:	6a 05                	push   $0x5
  jmp alltraps
80106276:	e9 ac f8 ff ff       	jmp    80105b27 <alltraps>

8010627b <vector6>:
.globl vector6
vector6:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $6
8010627d:	6a 06                	push   $0x6
  jmp alltraps
8010627f:	e9 a3 f8 ff ff       	jmp    80105b27 <alltraps>

80106284 <vector7>:
.globl vector7
vector7:
  pushl $0
80106284:	6a 00                	push   $0x0
  pushl $7
80106286:	6a 07                	push   $0x7
  jmp alltraps
80106288:	e9 9a f8 ff ff       	jmp    80105b27 <alltraps>

8010628d <vector8>:
.globl vector8
vector8:
  pushl $8
8010628d:	6a 08                	push   $0x8
  jmp alltraps
8010628f:	e9 93 f8 ff ff       	jmp    80105b27 <alltraps>

80106294 <vector9>:
.globl vector9
vector9:
  pushl $0
80106294:	6a 00                	push   $0x0
  pushl $9
80106296:	6a 09                	push   $0x9
  jmp alltraps
80106298:	e9 8a f8 ff ff       	jmp    80105b27 <alltraps>

8010629d <vector10>:
.globl vector10
vector10:
  pushl $10
8010629d:	6a 0a                	push   $0xa
  jmp alltraps
8010629f:	e9 83 f8 ff ff       	jmp    80105b27 <alltraps>

801062a4 <vector11>:
.globl vector11
vector11:
  pushl $11
801062a4:	6a 0b                	push   $0xb
  jmp alltraps
801062a6:	e9 7c f8 ff ff       	jmp    80105b27 <alltraps>

801062ab <vector12>:
.globl vector12
vector12:
  pushl $12
801062ab:	6a 0c                	push   $0xc
  jmp alltraps
801062ad:	e9 75 f8 ff ff       	jmp    80105b27 <alltraps>

801062b2 <vector13>:
.globl vector13
vector13:
  pushl $13
801062b2:	6a 0d                	push   $0xd
  jmp alltraps
801062b4:	e9 6e f8 ff ff       	jmp    80105b27 <alltraps>

801062b9 <vector14>:
.globl vector14
vector14:
  pushl $14
801062b9:	6a 0e                	push   $0xe
  jmp alltraps
801062bb:	e9 67 f8 ff ff       	jmp    80105b27 <alltraps>

801062c0 <vector15>:
.globl vector15
vector15:
  pushl $0
801062c0:	6a 00                	push   $0x0
  pushl $15
801062c2:	6a 0f                	push   $0xf
  jmp alltraps
801062c4:	e9 5e f8 ff ff       	jmp    80105b27 <alltraps>

801062c9 <vector16>:
.globl vector16
vector16:
  pushl $0
801062c9:	6a 00                	push   $0x0
  pushl $16
801062cb:	6a 10                	push   $0x10
  jmp alltraps
801062cd:	e9 55 f8 ff ff       	jmp    80105b27 <alltraps>

801062d2 <vector17>:
.globl vector17
vector17:
  pushl $17
801062d2:	6a 11                	push   $0x11
  jmp alltraps
801062d4:	e9 4e f8 ff ff       	jmp    80105b27 <alltraps>

801062d9 <vector18>:
.globl vector18
vector18:
  pushl $0
801062d9:	6a 00                	push   $0x0
  pushl $18
801062db:	6a 12                	push   $0x12
  jmp alltraps
801062dd:	e9 45 f8 ff ff       	jmp    80105b27 <alltraps>

801062e2 <vector19>:
.globl vector19
vector19:
  pushl $0
801062e2:	6a 00                	push   $0x0
  pushl $19
801062e4:	6a 13                	push   $0x13
  jmp alltraps
801062e6:	e9 3c f8 ff ff       	jmp    80105b27 <alltraps>

801062eb <vector20>:
.globl vector20
vector20:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $20
801062ed:	6a 14                	push   $0x14
  jmp alltraps
801062ef:	e9 33 f8 ff ff       	jmp    80105b27 <alltraps>

801062f4 <vector21>:
.globl vector21
vector21:
  pushl $0
801062f4:	6a 00                	push   $0x0
  pushl $21
801062f6:	6a 15                	push   $0x15
  jmp alltraps
801062f8:	e9 2a f8 ff ff       	jmp    80105b27 <alltraps>

801062fd <vector22>:
.globl vector22
vector22:
  pushl $0
801062fd:	6a 00                	push   $0x0
  pushl $22
801062ff:	6a 16                	push   $0x16
  jmp alltraps
80106301:	e9 21 f8 ff ff       	jmp    80105b27 <alltraps>

80106306 <vector23>:
.globl vector23
vector23:
  pushl $0
80106306:	6a 00                	push   $0x0
  pushl $23
80106308:	6a 17                	push   $0x17
  jmp alltraps
8010630a:	e9 18 f8 ff ff       	jmp    80105b27 <alltraps>

8010630f <vector24>:
.globl vector24
vector24:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $24
80106311:	6a 18                	push   $0x18
  jmp alltraps
80106313:	e9 0f f8 ff ff       	jmp    80105b27 <alltraps>

80106318 <vector25>:
.globl vector25
vector25:
  pushl $0
80106318:	6a 00                	push   $0x0
  pushl $25
8010631a:	6a 19                	push   $0x19
  jmp alltraps
8010631c:	e9 06 f8 ff ff       	jmp    80105b27 <alltraps>

80106321 <vector26>:
.globl vector26
vector26:
  pushl $0
80106321:	6a 00                	push   $0x0
  pushl $26
80106323:	6a 1a                	push   $0x1a
  jmp alltraps
80106325:	e9 fd f7 ff ff       	jmp    80105b27 <alltraps>

8010632a <vector27>:
.globl vector27
vector27:
  pushl $0
8010632a:	6a 00                	push   $0x0
  pushl $27
8010632c:	6a 1b                	push   $0x1b
  jmp alltraps
8010632e:	e9 f4 f7 ff ff       	jmp    80105b27 <alltraps>

80106333 <vector28>:
.globl vector28
vector28:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $28
80106335:	6a 1c                	push   $0x1c
  jmp alltraps
80106337:	e9 eb f7 ff ff       	jmp    80105b27 <alltraps>

8010633c <vector29>:
.globl vector29
vector29:
  pushl $0
8010633c:	6a 00                	push   $0x0
  pushl $29
8010633e:	6a 1d                	push   $0x1d
  jmp alltraps
80106340:	e9 e2 f7 ff ff       	jmp    80105b27 <alltraps>

80106345 <vector30>:
.globl vector30
vector30:
  pushl $0
80106345:	6a 00                	push   $0x0
  pushl $30
80106347:	6a 1e                	push   $0x1e
  jmp alltraps
80106349:	e9 d9 f7 ff ff       	jmp    80105b27 <alltraps>

8010634e <vector31>:
.globl vector31
vector31:
  pushl $0
8010634e:	6a 00                	push   $0x0
  pushl $31
80106350:	6a 1f                	push   $0x1f
  jmp alltraps
80106352:	e9 d0 f7 ff ff       	jmp    80105b27 <alltraps>

80106357 <vector32>:
.globl vector32
vector32:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $32
80106359:	6a 20                	push   $0x20
  jmp alltraps
8010635b:	e9 c7 f7 ff ff       	jmp    80105b27 <alltraps>

80106360 <vector33>:
.globl vector33
vector33:
  pushl $0
80106360:	6a 00                	push   $0x0
  pushl $33
80106362:	6a 21                	push   $0x21
  jmp alltraps
80106364:	e9 be f7 ff ff       	jmp    80105b27 <alltraps>

80106369 <vector34>:
.globl vector34
vector34:
  pushl $0
80106369:	6a 00                	push   $0x0
  pushl $34
8010636b:	6a 22                	push   $0x22
  jmp alltraps
8010636d:	e9 b5 f7 ff ff       	jmp    80105b27 <alltraps>

80106372 <vector35>:
.globl vector35
vector35:
  pushl $0
80106372:	6a 00                	push   $0x0
  pushl $35
80106374:	6a 23                	push   $0x23
  jmp alltraps
80106376:	e9 ac f7 ff ff       	jmp    80105b27 <alltraps>

8010637b <vector36>:
.globl vector36
vector36:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $36
8010637d:	6a 24                	push   $0x24
  jmp alltraps
8010637f:	e9 a3 f7 ff ff       	jmp    80105b27 <alltraps>

80106384 <vector37>:
.globl vector37
vector37:
  pushl $0
80106384:	6a 00                	push   $0x0
  pushl $37
80106386:	6a 25                	push   $0x25
  jmp alltraps
80106388:	e9 9a f7 ff ff       	jmp    80105b27 <alltraps>

8010638d <vector38>:
.globl vector38
vector38:
  pushl $0
8010638d:	6a 00                	push   $0x0
  pushl $38
8010638f:	6a 26                	push   $0x26
  jmp alltraps
80106391:	e9 91 f7 ff ff       	jmp    80105b27 <alltraps>

80106396 <vector39>:
.globl vector39
vector39:
  pushl $0
80106396:	6a 00                	push   $0x0
  pushl $39
80106398:	6a 27                	push   $0x27
  jmp alltraps
8010639a:	e9 88 f7 ff ff       	jmp    80105b27 <alltraps>

8010639f <vector40>:
.globl vector40
vector40:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $40
801063a1:	6a 28                	push   $0x28
  jmp alltraps
801063a3:	e9 7f f7 ff ff       	jmp    80105b27 <alltraps>

801063a8 <vector41>:
.globl vector41
vector41:
  pushl $0
801063a8:	6a 00                	push   $0x0
  pushl $41
801063aa:	6a 29                	push   $0x29
  jmp alltraps
801063ac:	e9 76 f7 ff ff       	jmp    80105b27 <alltraps>

801063b1 <vector42>:
.globl vector42
vector42:
  pushl $0
801063b1:	6a 00                	push   $0x0
  pushl $42
801063b3:	6a 2a                	push   $0x2a
  jmp alltraps
801063b5:	e9 6d f7 ff ff       	jmp    80105b27 <alltraps>

801063ba <vector43>:
.globl vector43
vector43:
  pushl $0
801063ba:	6a 00                	push   $0x0
  pushl $43
801063bc:	6a 2b                	push   $0x2b
  jmp alltraps
801063be:	e9 64 f7 ff ff       	jmp    80105b27 <alltraps>

801063c3 <vector44>:
.globl vector44
vector44:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $44
801063c5:	6a 2c                	push   $0x2c
  jmp alltraps
801063c7:	e9 5b f7 ff ff       	jmp    80105b27 <alltraps>

801063cc <vector45>:
.globl vector45
vector45:
  pushl $0
801063cc:	6a 00                	push   $0x0
  pushl $45
801063ce:	6a 2d                	push   $0x2d
  jmp alltraps
801063d0:	e9 52 f7 ff ff       	jmp    80105b27 <alltraps>

801063d5 <vector46>:
.globl vector46
vector46:
  pushl $0
801063d5:	6a 00                	push   $0x0
  pushl $46
801063d7:	6a 2e                	push   $0x2e
  jmp alltraps
801063d9:	e9 49 f7 ff ff       	jmp    80105b27 <alltraps>

801063de <vector47>:
.globl vector47
vector47:
  pushl $0
801063de:	6a 00                	push   $0x0
  pushl $47
801063e0:	6a 2f                	push   $0x2f
  jmp alltraps
801063e2:	e9 40 f7 ff ff       	jmp    80105b27 <alltraps>

801063e7 <vector48>:
.globl vector48
vector48:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $48
801063e9:	6a 30                	push   $0x30
  jmp alltraps
801063eb:	e9 37 f7 ff ff       	jmp    80105b27 <alltraps>

801063f0 <vector49>:
.globl vector49
vector49:
  pushl $0
801063f0:	6a 00                	push   $0x0
  pushl $49
801063f2:	6a 31                	push   $0x31
  jmp alltraps
801063f4:	e9 2e f7 ff ff       	jmp    80105b27 <alltraps>

801063f9 <vector50>:
.globl vector50
vector50:
  pushl $0
801063f9:	6a 00                	push   $0x0
  pushl $50
801063fb:	6a 32                	push   $0x32
  jmp alltraps
801063fd:	e9 25 f7 ff ff       	jmp    80105b27 <alltraps>

80106402 <vector51>:
.globl vector51
vector51:
  pushl $0
80106402:	6a 00                	push   $0x0
  pushl $51
80106404:	6a 33                	push   $0x33
  jmp alltraps
80106406:	e9 1c f7 ff ff       	jmp    80105b27 <alltraps>

8010640b <vector52>:
.globl vector52
vector52:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $52
8010640d:	6a 34                	push   $0x34
  jmp alltraps
8010640f:	e9 13 f7 ff ff       	jmp    80105b27 <alltraps>

80106414 <vector53>:
.globl vector53
vector53:
  pushl $0
80106414:	6a 00                	push   $0x0
  pushl $53
80106416:	6a 35                	push   $0x35
  jmp alltraps
80106418:	e9 0a f7 ff ff       	jmp    80105b27 <alltraps>

8010641d <vector54>:
.globl vector54
vector54:
  pushl $0
8010641d:	6a 00                	push   $0x0
  pushl $54
8010641f:	6a 36                	push   $0x36
  jmp alltraps
80106421:	e9 01 f7 ff ff       	jmp    80105b27 <alltraps>

80106426 <vector55>:
.globl vector55
vector55:
  pushl $0
80106426:	6a 00                	push   $0x0
  pushl $55
80106428:	6a 37                	push   $0x37
  jmp alltraps
8010642a:	e9 f8 f6 ff ff       	jmp    80105b27 <alltraps>

8010642f <vector56>:
.globl vector56
vector56:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $56
80106431:	6a 38                	push   $0x38
  jmp alltraps
80106433:	e9 ef f6 ff ff       	jmp    80105b27 <alltraps>

80106438 <vector57>:
.globl vector57
vector57:
  pushl $0
80106438:	6a 00                	push   $0x0
  pushl $57
8010643a:	6a 39                	push   $0x39
  jmp alltraps
8010643c:	e9 e6 f6 ff ff       	jmp    80105b27 <alltraps>

80106441 <vector58>:
.globl vector58
vector58:
  pushl $0
80106441:	6a 00                	push   $0x0
  pushl $58
80106443:	6a 3a                	push   $0x3a
  jmp alltraps
80106445:	e9 dd f6 ff ff       	jmp    80105b27 <alltraps>

8010644a <vector59>:
.globl vector59
vector59:
  pushl $0
8010644a:	6a 00                	push   $0x0
  pushl $59
8010644c:	6a 3b                	push   $0x3b
  jmp alltraps
8010644e:	e9 d4 f6 ff ff       	jmp    80105b27 <alltraps>

80106453 <vector60>:
.globl vector60
vector60:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $60
80106455:	6a 3c                	push   $0x3c
  jmp alltraps
80106457:	e9 cb f6 ff ff       	jmp    80105b27 <alltraps>

8010645c <vector61>:
.globl vector61
vector61:
  pushl $0
8010645c:	6a 00                	push   $0x0
  pushl $61
8010645e:	6a 3d                	push   $0x3d
  jmp alltraps
80106460:	e9 c2 f6 ff ff       	jmp    80105b27 <alltraps>

80106465 <vector62>:
.globl vector62
vector62:
  pushl $0
80106465:	6a 00                	push   $0x0
  pushl $62
80106467:	6a 3e                	push   $0x3e
  jmp alltraps
80106469:	e9 b9 f6 ff ff       	jmp    80105b27 <alltraps>

8010646e <vector63>:
.globl vector63
vector63:
  pushl $0
8010646e:	6a 00                	push   $0x0
  pushl $63
80106470:	6a 3f                	push   $0x3f
  jmp alltraps
80106472:	e9 b0 f6 ff ff       	jmp    80105b27 <alltraps>

80106477 <vector64>:
.globl vector64
vector64:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $64
80106479:	6a 40                	push   $0x40
  jmp alltraps
8010647b:	e9 a7 f6 ff ff       	jmp    80105b27 <alltraps>

80106480 <vector65>:
.globl vector65
vector65:
  pushl $0
80106480:	6a 00                	push   $0x0
  pushl $65
80106482:	6a 41                	push   $0x41
  jmp alltraps
80106484:	e9 9e f6 ff ff       	jmp    80105b27 <alltraps>

80106489 <vector66>:
.globl vector66
vector66:
  pushl $0
80106489:	6a 00                	push   $0x0
  pushl $66
8010648b:	6a 42                	push   $0x42
  jmp alltraps
8010648d:	e9 95 f6 ff ff       	jmp    80105b27 <alltraps>

80106492 <vector67>:
.globl vector67
vector67:
  pushl $0
80106492:	6a 00                	push   $0x0
  pushl $67
80106494:	6a 43                	push   $0x43
  jmp alltraps
80106496:	e9 8c f6 ff ff       	jmp    80105b27 <alltraps>

8010649b <vector68>:
.globl vector68
vector68:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $68
8010649d:	6a 44                	push   $0x44
  jmp alltraps
8010649f:	e9 83 f6 ff ff       	jmp    80105b27 <alltraps>

801064a4 <vector69>:
.globl vector69
vector69:
  pushl $0
801064a4:	6a 00                	push   $0x0
  pushl $69
801064a6:	6a 45                	push   $0x45
  jmp alltraps
801064a8:	e9 7a f6 ff ff       	jmp    80105b27 <alltraps>

801064ad <vector70>:
.globl vector70
vector70:
  pushl $0
801064ad:	6a 00                	push   $0x0
  pushl $70
801064af:	6a 46                	push   $0x46
  jmp alltraps
801064b1:	e9 71 f6 ff ff       	jmp    80105b27 <alltraps>

801064b6 <vector71>:
.globl vector71
vector71:
  pushl $0
801064b6:	6a 00                	push   $0x0
  pushl $71
801064b8:	6a 47                	push   $0x47
  jmp alltraps
801064ba:	e9 68 f6 ff ff       	jmp    80105b27 <alltraps>

801064bf <vector72>:
.globl vector72
vector72:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $72
801064c1:	6a 48                	push   $0x48
  jmp alltraps
801064c3:	e9 5f f6 ff ff       	jmp    80105b27 <alltraps>

801064c8 <vector73>:
.globl vector73
vector73:
  pushl $0
801064c8:	6a 00                	push   $0x0
  pushl $73
801064ca:	6a 49                	push   $0x49
  jmp alltraps
801064cc:	e9 56 f6 ff ff       	jmp    80105b27 <alltraps>

801064d1 <vector74>:
.globl vector74
vector74:
  pushl $0
801064d1:	6a 00                	push   $0x0
  pushl $74
801064d3:	6a 4a                	push   $0x4a
  jmp alltraps
801064d5:	e9 4d f6 ff ff       	jmp    80105b27 <alltraps>

801064da <vector75>:
.globl vector75
vector75:
  pushl $0
801064da:	6a 00                	push   $0x0
  pushl $75
801064dc:	6a 4b                	push   $0x4b
  jmp alltraps
801064de:	e9 44 f6 ff ff       	jmp    80105b27 <alltraps>

801064e3 <vector76>:
.globl vector76
vector76:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $76
801064e5:	6a 4c                	push   $0x4c
  jmp alltraps
801064e7:	e9 3b f6 ff ff       	jmp    80105b27 <alltraps>

801064ec <vector77>:
.globl vector77
vector77:
  pushl $0
801064ec:	6a 00                	push   $0x0
  pushl $77
801064ee:	6a 4d                	push   $0x4d
  jmp alltraps
801064f0:	e9 32 f6 ff ff       	jmp    80105b27 <alltraps>

801064f5 <vector78>:
.globl vector78
vector78:
  pushl $0
801064f5:	6a 00                	push   $0x0
  pushl $78
801064f7:	6a 4e                	push   $0x4e
  jmp alltraps
801064f9:	e9 29 f6 ff ff       	jmp    80105b27 <alltraps>

801064fe <vector79>:
.globl vector79
vector79:
  pushl $0
801064fe:	6a 00                	push   $0x0
  pushl $79
80106500:	6a 4f                	push   $0x4f
  jmp alltraps
80106502:	e9 20 f6 ff ff       	jmp    80105b27 <alltraps>

80106507 <vector80>:
.globl vector80
vector80:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $80
80106509:	6a 50                	push   $0x50
  jmp alltraps
8010650b:	e9 17 f6 ff ff       	jmp    80105b27 <alltraps>

80106510 <vector81>:
.globl vector81
vector81:
  pushl $0
80106510:	6a 00                	push   $0x0
  pushl $81
80106512:	6a 51                	push   $0x51
  jmp alltraps
80106514:	e9 0e f6 ff ff       	jmp    80105b27 <alltraps>

80106519 <vector82>:
.globl vector82
vector82:
  pushl $0
80106519:	6a 00                	push   $0x0
  pushl $82
8010651b:	6a 52                	push   $0x52
  jmp alltraps
8010651d:	e9 05 f6 ff ff       	jmp    80105b27 <alltraps>

80106522 <vector83>:
.globl vector83
vector83:
  pushl $0
80106522:	6a 00                	push   $0x0
  pushl $83
80106524:	6a 53                	push   $0x53
  jmp alltraps
80106526:	e9 fc f5 ff ff       	jmp    80105b27 <alltraps>

8010652b <vector84>:
.globl vector84
vector84:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $84
8010652d:	6a 54                	push   $0x54
  jmp alltraps
8010652f:	e9 f3 f5 ff ff       	jmp    80105b27 <alltraps>

80106534 <vector85>:
.globl vector85
vector85:
  pushl $0
80106534:	6a 00                	push   $0x0
  pushl $85
80106536:	6a 55                	push   $0x55
  jmp alltraps
80106538:	e9 ea f5 ff ff       	jmp    80105b27 <alltraps>

8010653d <vector86>:
.globl vector86
vector86:
  pushl $0
8010653d:	6a 00                	push   $0x0
  pushl $86
8010653f:	6a 56                	push   $0x56
  jmp alltraps
80106541:	e9 e1 f5 ff ff       	jmp    80105b27 <alltraps>

80106546 <vector87>:
.globl vector87
vector87:
  pushl $0
80106546:	6a 00                	push   $0x0
  pushl $87
80106548:	6a 57                	push   $0x57
  jmp alltraps
8010654a:	e9 d8 f5 ff ff       	jmp    80105b27 <alltraps>

8010654f <vector88>:
.globl vector88
vector88:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $88
80106551:	6a 58                	push   $0x58
  jmp alltraps
80106553:	e9 cf f5 ff ff       	jmp    80105b27 <alltraps>

80106558 <vector89>:
.globl vector89
vector89:
  pushl $0
80106558:	6a 00                	push   $0x0
  pushl $89
8010655a:	6a 59                	push   $0x59
  jmp alltraps
8010655c:	e9 c6 f5 ff ff       	jmp    80105b27 <alltraps>

80106561 <vector90>:
.globl vector90
vector90:
  pushl $0
80106561:	6a 00                	push   $0x0
  pushl $90
80106563:	6a 5a                	push   $0x5a
  jmp alltraps
80106565:	e9 bd f5 ff ff       	jmp    80105b27 <alltraps>

8010656a <vector91>:
.globl vector91
vector91:
  pushl $0
8010656a:	6a 00                	push   $0x0
  pushl $91
8010656c:	6a 5b                	push   $0x5b
  jmp alltraps
8010656e:	e9 b4 f5 ff ff       	jmp    80105b27 <alltraps>

80106573 <vector92>:
.globl vector92
vector92:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $92
80106575:	6a 5c                	push   $0x5c
  jmp alltraps
80106577:	e9 ab f5 ff ff       	jmp    80105b27 <alltraps>

8010657c <vector93>:
.globl vector93
vector93:
  pushl $0
8010657c:	6a 00                	push   $0x0
  pushl $93
8010657e:	6a 5d                	push   $0x5d
  jmp alltraps
80106580:	e9 a2 f5 ff ff       	jmp    80105b27 <alltraps>

80106585 <vector94>:
.globl vector94
vector94:
  pushl $0
80106585:	6a 00                	push   $0x0
  pushl $94
80106587:	6a 5e                	push   $0x5e
  jmp alltraps
80106589:	e9 99 f5 ff ff       	jmp    80105b27 <alltraps>

8010658e <vector95>:
.globl vector95
vector95:
  pushl $0
8010658e:	6a 00                	push   $0x0
  pushl $95
80106590:	6a 5f                	push   $0x5f
  jmp alltraps
80106592:	e9 90 f5 ff ff       	jmp    80105b27 <alltraps>

80106597 <vector96>:
.globl vector96
vector96:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $96
80106599:	6a 60                	push   $0x60
  jmp alltraps
8010659b:	e9 87 f5 ff ff       	jmp    80105b27 <alltraps>

801065a0 <vector97>:
.globl vector97
vector97:
  pushl $0
801065a0:	6a 00                	push   $0x0
  pushl $97
801065a2:	6a 61                	push   $0x61
  jmp alltraps
801065a4:	e9 7e f5 ff ff       	jmp    80105b27 <alltraps>

801065a9 <vector98>:
.globl vector98
vector98:
  pushl $0
801065a9:	6a 00                	push   $0x0
  pushl $98
801065ab:	6a 62                	push   $0x62
  jmp alltraps
801065ad:	e9 75 f5 ff ff       	jmp    80105b27 <alltraps>

801065b2 <vector99>:
.globl vector99
vector99:
  pushl $0
801065b2:	6a 00                	push   $0x0
  pushl $99
801065b4:	6a 63                	push   $0x63
  jmp alltraps
801065b6:	e9 6c f5 ff ff       	jmp    80105b27 <alltraps>

801065bb <vector100>:
.globl vector100
vector100:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $100
801065bd:	6a 64                	push   $0x64
  jmp alltraps
801065bf:	e9 63 f5 ff ff       	jmp    80105b27 <alltraps>

801065c4 <vector101>:
.globl vector101
vector101:
  pushl $0
801065c4:	6a 00                	push   $0x0
  pushl $101
801065c6:	6a 65                	push   $0x65
  jmp alltraps
801065c8:	e9 5a f5 ff ff       	jmp    80105b27 <alltraps>

801065cd <vector102>:
.globl vector102
vector102:
  pushl $0
801065cd:	6a 00                	push   $0x0
  pushl $102
801065cf:	6a 66                	push   $0x66
  jmp alltraps
801065d1:	e9 51 f5 ff ff       	jmp    80105b27 <alltraps>

801065d6 <vector103>:
.globl vector103
vector103:
  pushl $0
801065d6:	6a 00                	push   $0x0
  pushl $103
801065d8:	6a 67                	push   $0x67
  jmp alltraps
801065da:	e9 48 f5 ff ff       	jmp    80105b27 <alltraps>

801065df <vector104>:
.globl vector104
vector104:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $104
801065e1:	6a 68                	push   $0x68
  jmp alltraps
801065e3:	e9 3f f5 ff ff       	jmp    80105b27 <alltraps>

801065e8 <vector105>:
.globl vector105
vector105:
  pushl $0
801065e8:	6a 00                	push   $0x0
  pushl $105
801065ea:	6a 69                	push   $0x69
  jmp alltraps
801065ec:	e9 36 f5 ff ff       	jmp    80105b27 <alltraps>

801065f1 <vector106>:
.globl vector106
vector106:
  pushl $0
801065f1:	6a 00                	push   $0x0
  pushl $106
801065f3:	6a 6a                	push   $0x6a
  jmp alltraps
801065f5:	e9 2d f5 ff ff       	jmp    80105b27 <alltraps>

801065fa <vector107>:
.globl vector107
vector107:
  pushl $0
801065fa:	6a 00                	push   $0x0
  pushl $107
801065fc:	6a 6b                	push   $0x6b
  jmp alltraps
801065fe:	e9 24 f5 ff ff       	jmp    80105b27 <alltraps>

80106603 <vector108>:
.globl vector108
vector108:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $108
80106605:	6a 6c                	push   $0x6c
  jmp alltraps
80106607:	e9 1b f5 ff ff       	jmp    80105b27 <alltraps>

8010660c <vector109>:
.globl vector109
vector109:
  pushl $0
8010660c:	6a 00                	push   $0x0
  pushl $109
8010660e:	6a 6d                	push   $0x6d
  jmp alltraps
80106610:	e9 12 f5 ff ff       	jmp    80105b27 <alltraps>

80106615 <vector110>:
.globl vector110
vector110:
  pushl $0
80106615:	6a 00                	push   $0x0
  pushl $110
80106617:	6a 6e                	push   $0x6e
  jmp alltraps
80106619:	e9 09 f5 ff ff       	jmp    80105b27 <alltraps>

8010661e <vector111>:
.globl vector111
vector111:
  pushl $0
8010661e:	6a 00                	push   $0x0
  pushl $111
80106620:	6a 6f                	push   $0x6f
  jmp alltraps
80106622:	e9 00 f5 ff ff       	jmp    80105b27 <alltraps>

80106627 <vector112>:
.globl vector112
vector112:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $112
80106629:	6a 70                	push   $0x70
  jmp alltraps
8010662b:	e9 f7 f4 ff ff       	jmp    80105b27 <alltraps>

80106630 <vector113>:
.globl vector113
vector113:
  pushl $0
80106630:	6a 00                	push   $0x0
  pushl $113
80106632:	6a 71                	push   $0x71
  jmp alltraps
80106634:	e9 ee f4 ff ff       	jmp    80105b27 <alltraps>

80106639 <vector114>:
.globl vector114
vector114:
  pushl $0
80106639:	6a 00                	push   $0x0
  pushl $114
8010663b:	6a 72                	push   $0x72
  jmp alltraps
8010663d:	e9 e5 f4 ff ff       	jmp    80105b27 <alltraps>

80106642 <vector115>:
.globl vector115
vector115:
  pushl $0
80106642:	6a 00                	push   $0x0
  pushl $115
80106644:	6a 73                	push   $0x73
  jmp alltraps
80106646:	e9 dc f4 ff ff       	jmp    80105b27 <alltraps>

8010664b <vector116>:
.globl vector116
vector116:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $116
8010664d:	6a 74                	push   $0x74
  jmp alltraps
8010664f:	e9 d3 f4 ff ff       	jmp    80105b27 <alltraps>

80106654 <vector117>:
.globl vector117
vector117:
  pushl $0
80106654:	6a 00                	push   $0x0
  pushl $117
80106656:	6a 75                	push   $0x75
  jmp alltraps
80106658:	e9 ca f4 ff ff       	jmp    80105b27 <alltraps>

8010665d <vector118>:
.globl vector118
vector118:
  pushl $0
8010665d:	6a 00                	push   $0x0
  pushl $118
8010665f:	6a 76                	push   $0x76
  jmp alltraps
80106661:	e9 c1 f4 ff ff       	jmp    80105b27 <alltraps>

80106666 <vector119>:
.globl vector119
vector119:
  pushl $0
80106666:	6a 00                	push   $0x0
  pushl $119
80106668:	6a 77                	push   $0x77
  jmp alltraps
8010666a:	e9 b8 f4 ff ff       	jmp    80105b27 <alltraps>

8010666f <vector120>:
.globl vector120
vector120:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $120
80106671:	6a 78                	push   $0x78
  jmp alltraps
80106673:	e9 af f4 ff ff       	jmp    80105b27 <alltraps>

80106678 <vector121>:
.globl vector121
vector121:
  pushl $0
80106678:	6a 00                	push   $0x0
  pushl $121
8010667a:	6a 79                	push   $0x79
  jmp alltraps
8010667c:	e9 a6 f4 ff ff       	jmp    80105b27 <alltraps>

80106681 <vector122>:
.globl vector122
vector122:
  pushl $0
80106681:	6a 00                	push   $0x0
  pushl $122
80106683:	6a 7a                	push   $0x7a
  jmp alltraps
80106685:	e9 9d f4 ff ff       	jmp    80105b27 <alltraps>

8010668a <vector123>:
.globl vector123
vector123:
  pushl $0
8010668a:	6a 00                	push   $0x0
  pushl $123
8010668c:	6a 7b                	push   $0x7b
  jmp alltraps
8010668e:	e9 94 f4 ff ff       	jmp    80105b27 <alltraps>

80106693 <vector124>:
.globl vector124
vector124:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $124
80106695:	6a 7c                	push   $0x7c
  jmp alltraps
80106697:	e9 8b f4 ff ff       	jmp    80105b27 <alltraps>

8010669c <vector125>:
.globl vector125
vector125:
  pushl $0
8010669c:	6a 00                	push   $0x0
  pushl $125
8010669e:	6a 7d                	push   $0x7d
  jmp alltraps
801066a0:	e9 82 f4 ff ff       	jmp    80105b27 <alltraps>

801066a5 <vector126>:
.globl vector126
vector126:
  pushl $0
801066a5:	6a 00                	push   $0x0
  pushl $126
801066a7:	6a 7e                	push   $0x7e
  jmp alltraps
801066a9:	e9 79 f4 ff ff       	jmp    80105b27 <alltraps>

801066ae <vector127>:
.globl vector127
vector127:
  pushl $0
801066ae:	6a 00                	push   $0x0
  pushl $127
801066b0:	6a 7f                	push   $0x7f
  jmp alltraps
801066b2:	e9 70 f4 ff ff       	jmp    80105b27 <alltraps>

801066b7 <vector128>:
.globl vector128
vector128:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $128
801066b9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801066be:	e9 64 f4 ff ff       	jmp    80105b27 <alltraps>

801066c3 <vector129>:
.globl vector129
vector129:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $129
801066c5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801066ca:	e9 58 f4 ff ff       	jmp    80105b27 <alltraps>

801066cf <vector130>:
.globl vector130
vector130:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $130
801066d1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801066d6:	e9 4c f4 ff ff       	jmp    80105b27 <alltraps>

801066db <vector131>:
.globl vector131
vector131:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $131
801066dd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801066e2:	e9 40 f4 ff ff       	jmp    80105b27 <alltraps>

801066e7 <vector132>:
.globl vector132
vector132:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $132
801066e9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801066ee:	e9 34 f4 ff ff       	jmp    80105b27 <alltraps>

801066f3 <vector133>:
.globl vector133
vector133:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $133
801066f5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801066fa:	e9 28 f4 ff ff       	jmp    80105b27 <alltraps>

801066ff <vector134>:
.globl vector134
vector134:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $134
80106701:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106706:	e9 1c f4 ff ff       	jmp    80105b27 <alltraps>

8010670b <vector135>:
.globl vector135
vector135:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $135
8010670d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106712:	e9 10 f4 ff ff       	jmp    80105b27 <alltraps>

80106717 <vector136>:
.globl vector136
vector136:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $136
80106719:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010671e:	e9 04 f4 ff ff       	jmp    80105b27 <alltraps>

80106723 <vector137>:
.globl vector137
vector137:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $137
80106725:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010672a:	e9 f8 f3 ff ff       	jmp    80105b27 <alltraps>

8010672f <vector138>:
.globl vector138
vector138:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $138
80106731:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106736:	e9 ec f3 ff ff       	jmp    80105b27 <alltraps>

8010673b <vector139>:
.globl vector139
vector139:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $139
8010673d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106742:	e9 e0 f3 ff ff       	jmp    80105b27 <alltraps>

80106747 <vector140>:
.globl vector140
vector140:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $140
80106749:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010674e:	e9 d4 f3 ff ff       	jmp    80105b27 <alltraps>

80106753 <vector141>:
.globl vector141
vector141:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $141
80106755:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010675a:	e9 c8 f3 ff ff       	jmp    80105b27 <alltraps>

8010675f <vector142>:
.globl vector142
vector142:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $142
80106761:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106766:	e9 bc f3 ff ff       	jmp    80105b27 <alltraps>

8010676b <vector143>:
.globl vector143
vector143:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $143
8010676d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106772:	e9 b0 f3 ff ff       	jmp    80105b27 <alltraps>

80106777 <vector144>:
.globl vector144
vector144:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $144
80106779:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010677e:	e9 a4 f3 ff ff       	jmp    80105b27 <alltraps>

80106783 <vector145>:
.globl vector145
vector145:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $145
80106785:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010678a:	e9 98 f3 ff ff       	jmp    80105b27 <alltraps>

8010678f <vector146>:
.globl vector146
vector146:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $146
80106791:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106796:	e9 8c f3 ff ff       	jmp    80105b27 <alltraps>

8010679b <vector147>:
.globl vector147
vector147:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $147
8010679d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801067a2:	e9 80 f3 ff ff       	jmp    80105b27 <alltraps>

801067a7 <vector148>:
.globl vector148
vector148:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $148
801067a9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801067ae:	e9 74 f3 ff ff       	jmp    80105b27 <alltraps>

801067b3 <vector149>:
.globl vector149
vector149:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $149
801067b5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801067ba:	e9 68 f3 ff ff       	jmp    80105b27 <alltraps>

801067bf <vector150>:
.globl vector150
vector150:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $150
801067c1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801067c6:	e9 5c f3 ff ff       	jmp    80105b27 <alltraps>

801067cb <vector151>:
.globl vector151
vector151:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $151
801067cd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801067d2:	e9 50 f3 ff ff       	jmp    80105b27 <alltraps>

801067d7 <vector152>:
.globl vector152
vector152:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $152
801067d9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801067de:	e9 44 f3 ff ff       	jmp    80105b27 <alltraps>

801067e3 <vector153>:
.globl vector153
vector153:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $153
801067e5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801067ea:	e9 38 f3 ff ff       	jmp    80105b27 <alltraps>

801067ef <vector154>:
.globl vector154
vector154:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $154
801067f1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801067f6:	e9 2c f3 ff ff       	jmp    80105b27 <alltraps>

801067fb <vector155>:
.globl vector155
vector155:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $155
801067fd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106802:	e9 20 f3 ff ff       	jmp    80105b27 <alltraps>

80106807 <vector156>:
.globl vector156
vector156:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $156
80106809:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010680e:	e9 14 f3 ff ff       	jmp    80105b27 <alltraps>

80106813 <vector157>:
.globl vector157
vector157:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $157
80106815:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010681a:	e9 08 f3 ff ff       	jmp    80105b27 <alltraps>

8010681f <vector158>:
.globl vector158
vector158:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $158
80106821:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106826:	e9 fc f2 ff ff       	jmp    80105b27 <alltraps>

8010682b <vector159>:
.globl vector159
vector159:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $159
8010682d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106832:	e9 f0 f2 ff ff       	jmp    80105b27 <alltraps>

80106837 <vector160>:
.globl vector160
vector160:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $160
80106839:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010683e:	e9 e4 f2 ff ff       	jmp    80105b27 <alltraps>

80106843 <vector161>:
.globl vector161
vector161:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $161
80106845:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010684a:	e9 d8 f2 ff ff       	jmp    80105b27 <alltraps>

8010684f <vector162>:
.globl vector162
vector162:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $162
80106851:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106856:	e9 cc f2 ff ff       	jmp    80105b27 <alltraps>

8010685b <vector163>:
.globl vector163
vector163:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $163
8010685d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106862:	e9 c0 f2 ff ff       	jmp    80105b27 <alltraps>

80106867 <vector164>:
.globl vector164
vector164:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $164
80106869:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010686e:	e9 b4 f2 ff ff       	jmp    80105b27 <alltraps>

80106873 <vector165>:
.globl vector165
vector165:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $165
80106875:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010687a:	e9 a8 f2 ff ff       	jmp    80105b27 <alltraps>

8010687f <vector166>:
.globl vector166
vector166:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $166
80106881:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106886:	e9 9c f2 ff ff       	jmp    80105b27 <alltraps>

8010688b <vector167>:
.globl vector167
vector167:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $167
8010688d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106892:	e9 90 f2 ff ff       	jmp    80105b27 <alltraps>

80106897 <vector168>:
.globl vector168
vector168:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $168
80106899:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010689e:	e9 84 f2 ff ff       	jmp    80105b27 <alltraps>

801068a3 <vector169>:
.globl vector169
vector169:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $169
801068a5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801068aa:	e9 78 f2 ff ff       	jmp    80105b27 <alltraps>

801068af <vector170>:
.globl vector170
vector170:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $170
801068b1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801068b6:	e9 6c f2 ff ff       	jmp    80105b27 <alltraps>

801068bb <vector171>:
.globl vector171
vector171:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $171
801068bd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801068c2:	e9 60 f2 ff ff       	jmp    80105b27 <alltraps>

801068c7 <vector172>:
.globl vector172
vector172:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $172
801068c9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801068ce:	e9 54 f2 ff ff       	jmp    80105b27 <alltraps>

801068d3 <vector173>:
.globl vector173
vector173:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $173
801068d5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801068da:	e9 48 f2 ff ff       	jmp    80105b27 <alltraps>

801068df <vector174>:
.globl vector174
vector174:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $174
801068e1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801068e6:	e9 3c f2 ff ff       	jmp    80105b27 <alltraps>

801068eb <vector175>:
.globl vector175
vector175:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $175
801068ed:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801068f2:	e9 30 f2 ff ff       	jmp    80105b27 <alltraps>

801068f7 <vector176>:
.globl vector176
vector176:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $176
801068f9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801068fe:	e9 24 f2 ff ff       	jmp    80105b27 <alltraps>

80106903 <vector177>:
.globl vector177
vector177:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $177
80106905:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010690a:	e9 18 f2 ff ff       	jmp    80105b27 <alltraps>

8010690f <vector178>:
.globl vector178
vector178:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $178
80106911:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106916:	e9 0c f2 ff ff       	jmp    80105b27 <alltraps>

8010691b <vector179>:
.globl vector179
vector179:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $179
8010691d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106922:	e9 00 f2 ff ff       	jmp    80105b27 <alltraps>

80106927 <vector180>:
.globl vector180
vector180:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $180
80106929:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010692e:	e9 f4 f1 ff ff       	jmp    80105b27 <alltraps>

80106933 <vector181>:
.globl vector181
vector181:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $181
80106935:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010693a:	e9 e8 f1 ff ff       	jmp    80105b27 <alltraps>

8010693f <vector182>:
.globl vector182
vector182:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $182
80106941:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106946:	e9 dc f1 ff ff       	jmp    80105b27 <alltraps>

8010694b <vector183>:
.globl vector183
vector183:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $183
8010694d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106952:	e9 d0 f1 ff ff       	jmp    80105b27 <alltraps>

80106957 <vector184>:
.globl vector184
vector184:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $184
80106959:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010695e:	e9 c4 f1 ff ff       	jmp    80105b27 <alltraps>

80106963 <vector185>:
.globl vector185
vector185:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $185
80106965:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010696a:	e9 b8 f1 ff ff       	jmp    80105b27 <alltraps>

8010696f <vector186>:
.globl vector186
vector186:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $186
80106971:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106976:	e9 ac f1 ff ff       	jmp    80105b27 <alltraps>

8010697b <vector187>:
.globl vector187
vector187:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $187
8010697d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106982:	e9 a0 f1 ff ff       	jmp    80105b27 <alltraps>

80106987 <vector188>:
.globl vector188
vector188:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $188
80106989:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010698e:	e9 94 f1 ff ff       	jmp    80105b27 <alltraps>

80106993 <vector189>:
.globl vector189
vector189:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $189
80106995:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010699a:	e9 88 f1 ff ff       	jmp    80105b27 <alltraps>

8010699f <vector190>:
.globl vector190
vector190:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $190
801069a1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801069a6:	e9 7c f1 ff ff       	jmp    80105b27 <alltraps>

801069ab <vector191>:
.globl vector191
vector191:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $191
801069ad:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801069b2:	e9 70 f1 ff ff       	jmp    80105b27 <alltraps>

801069b7 <vector192>:
.globl vector192
vector192:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $192
801069b9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801069be:	e9 64 f1 ff ff       	jmp    80105b27 <alltraps>

801069c3 <vector193>:
.globl vector193
vector193:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $193
801069c5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801069ca:	e9 58 f1 ff ff       	jmp    80105b27 <alltraps>

801069cf <vector194>:
.globl vector194
vector194:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $194
801069d1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801069d6:	e9 4c f1 ff ff       	jmp    80105b27 <alltraps>

801069db <vector195>:
.globl vector195
vector195:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $195
801069dd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801069e2:	e9 40 f1 ff ff       	jmp    80105b27 <alltraps>

801069e7 <vector196>:
.globl vector196
vector196:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $196
801069e9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801069ee:	e9 34 f1 ff ff       	jmp    80105b27 <alltraps>

801069f3 <vector197>:
.globl vector197
vector197:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $197
801069f5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801069fa:	e9 28 f1 ff ff       	jmp    80105b27 <alltraps>

801069ff <vector198>:
.globl vector198
vector198:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $198
80106a01:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106a06:	e9 1c f1 ff ff       	jmp    80105b27 <alltraps>

80106a0b <vector199>:
.globl vector199
vector199:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $199
80106a0d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106a12:	e9 10 f1 ff ff       	jmp    80105b27 <alltraps>

80106a17 <vector200>:
.globl vector200
vector200:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $200
80106a19:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106a1e:	e9 04 f1 ff ff       	jmp    80105b27 <alltraps>

80106a23 <vector201>:
.globl vector201
vector201:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $201
80106a25:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106a2a:	e9 f8 f0 ff ff       	jmp    80105b27 <alltraps>

80106a2f <vector202>:
.globl vector202
vector202:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $202
80106a31:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106a36:	e9 ec f0 ff ff       	jmp    80105b27 <alltraps>

80106a3b <vector203>:
.globl vector203
vector203:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $203
80106a3d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106a42:	e9 e0 f0 ff ff       	jmp    80105b27 <alltraps>

80106a47 <vector204>:
.globl vector204
vector204:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $204
80106a49:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106a4e:	e9 d4 f0 ff ff       	jmp    80105b27 <alltraps>

80106a53 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $205
80106a55:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a5a:	e9 c8 f0 ff ff       	jmp    80105b27 <alltraps>

80106a5f <vector206>:
.globl vector206
vector206:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $206
80106a61:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a66:	e9 bc f0 ff ff       	jmp    80105b27 <alltraps>

80106a6b <vector207>:
.globl vector207
vector207:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $207
80106a6d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a72:	e9 b0 f0 ff ff       	jmp    80105b27 <alltraps>

80106a77 <vector208>:
.globl vector208
vector208:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $208
80106a79:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a7e:	e9 a4 f0 ff ff       	jmp    80105b27 <alltraps>

80106a83 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $209
80106a85:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a8a:	e9 98 f0 ff ff       	jmp    80105b27 <alltraps>

80106a8f <vector210>:
.globl vector210
vector210:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $210
80106a91:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a96:	e9 8c f0 ff ff       	jmp    80105b27 <alltraps>

80106a9b <vector211>:
.globl vector211
vector211:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $211
80106a9d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106aa2:	e9 80 f0 ff ff       	jmp    80105b27 <alltraps>

80106aa7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $212
80106aa9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106aae:	e9 74 f0 ff ff       	jmp    80105b27 <alltraps>

80106ab3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $213
80106ab5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106aba:	e9 68 f0 ff ff       	jmp    80105b27 <alltraps>

80106abf <vector214>:
.globl vector214
vector214:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $214
80106ac1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ac6:	e9 5c f0 ff ff       	jmp    80105b27 <alltraps>

80106acb <vector215>:
.globl vector215
vector215:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $215
80106acd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106ad2:	e9 50 f0 ff ff       	jmp    80105b27 <alltraps>

80106ad7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $216
80106ad9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106ade:	e9 44 f0 ff ff       	jmp    80105b27 <alltraps>

80106ae3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $217
80106ae5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106aea:	e9 38 f0 ff ff       	jmp    80105b27 <alltraps>

80106aef <vector218>:
.globl vector218
vector218:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $218
80106af1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106af6:	e9 2c f0 ff ff       	jmp    80105b27 <alltraps>

80106afb <vector219>:
.globl vector219
vector219:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $219
80106afd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106b02:	e9 20 f0 ff ff       	jmp    80105b27 <alltraps>

80106b07 <vector220>:
.globl vector220
vector220:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $220
80106b09:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106b0e:	e9 14 f0 ff ff       	jmp    80105b27 <alltraps>

80106b13 <vector221>:
.globl vector221
vector221:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $221
80106b15:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106b1a:	e9 08 f0 ff ff       	jmp    80105b27 <alltraps>

80106b1f <vector222>:
.globl vector222
vector222:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $222
80106b21:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106b26:	e9 fc ef ff ff       	jmp    80105b27 <alltraps>

80106b2b <vector223>:
.globl vector223
vector223:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $223
80106b2d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106b32:	e9 f0 ef ff ff       	jmp    80105b27 <alltraps>

80106b37 <vector224>:
.globl vector224
vector224:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $224
80106b39:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b3e:	e9 e4 ef ff ff       	jmp    80105b27 <alltraps>

80106b43 <vector225>:
.globl vector225
vector225:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $225
80106b45:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106b4a:	e9 d8 ef ff ff       	jmp    80105b27 <alltraps>

80106b4f <vector226>:
.globl vector226
vector226:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $226
80106b51:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b56:	e9 cc ef ff ff       	jmp    80105b27 <alltraps>

80106b5b <vector227>:
.globl vector227
vector227:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $227
80106b5d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b62:	e9 c0 ef ff ff       	jmp    80105b27 <alltraps>

80106b67 <vector228>:
.globl vector228
vector228:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $228
80106b69:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b6e:	e9 b4 ef ff ff       	jmp    80105b27 <alltraps>

80106b73 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $229
80106b75:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b7a:	e9 a8 ef ff ff       	jmp    80105b27 <alltraps>

80106b7f <vector230>:
.globl vector230
vector230:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $230
80106b81:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b86:	e9 9c ef ff ff       	jmp    80105b27 <alltraps>

80106b8b <vector231>:
.globl vector231
vector231:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $231
80106b8d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b92:	e9 90 ef ff ff       	jmp    80105b27 <alltraps>

80106b97 <vector232>:
.globl vector232
vector232:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $232
80106b99:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b9e:	e9 84 ef ff ff       	jmp    80105b27 <alltraps>

80106ba3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $233
80106ba5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106baa:	e9 78 ef ff ff       	jmp    80105b27 <alltraps>

80106baf <vector234>:
.globl vector234
vector234:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $234
80106bb1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106bb6:	e9 6c ef ff ff       	jmp    80105b27 <alltraps>

80106bbb <vector235>:
.globl vector235
vector235:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $235
80106bbd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106bc2:	e9 60 ef ff ff       	jmp    80105b27 <alltraps>

80106bc7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $236
80106bc9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106bce:	e9 54 ef ff ff       	jmp    80105b27 <alltraps>

80106bd3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $237
80106bd5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106bda:	e9 48 ef ff ff       	jmp    80105b27 <alltraps>

80106bdf <vector238>:
.globl vector238
vector238:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $238
80106be1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106be6:	e9 3c ef ff ff       	jmp    80105b27 <alltraps>

80106beb <vector239>:
.globl vector239
vector239:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $239
80106bed:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106bf2:	e9 30 ef ff ff       	jmp    80105b27 <alltraps>

80106bf7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $240
80106bf9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106bfe:	e9 24 ef ff ff       	jmp    80105b27 <alltraps>

80106c03 <vector241>:
.globl vector241
vector241:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $241
80106c05:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106c0a:	e9 18 ef ff ff       	jmp    80105b27 <alltraps>

80106c0f <vector242>:
.globl vector242
vector242:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $242
80106c11:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106c16:	e9 0c ef ff ff       	jmp    80105b27 <alltraps>

80106c1b <vector243>:
.globl vector243
vector243:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $243
80106c1d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106c22:	e9 00 ef ff ff       	jmp    80105b27 <alltraps>

80106c27 <vector244>:
.globl vector244
vector244:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $244
80106c29:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106c2e:	e9 f4 ee ff ff       	jmp    80105b27 <alltraps>

80106c33 <vector245>:
.globl vector245
vector245:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $245
80106c35:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106c3a:	e9 e8 ee ff ff       	jmp    80105b27 <alltraps>

80106c3f <vector246>:
.globl vector246
vector246:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $246
80106c41:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106c46:	e9 dc ee ff ff       	jmp    80105b27 <alltraps>

80106c4b <vector247>:
.globl vector247
vector247:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $247
80106c4d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c52:	e9 d0 ee ff ff       	jmp    80105b27 <alltraps>

80106c57 <vector248>:
.globl vector248
vector248:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $248
80106c59:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c5e:	e9 c4 ee ff ff       	jmp    80105b27 <alltraps>

80106c63 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $249
80106c65:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c6a:	e9 b8 ee ff ff       	jmp    80105b27 <alltraps>

80106c6f <vector250>:
.globl vector250
vector250:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $250
80106c71:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c76:	e9 ac ee ff ff       	jmp    80105b27 <alltraps>

80106c7b <vector251>:
.globl vector251
vector251:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $251
80106c7d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c82:	e9 a0 ee ff ff       	jmp    80105b27 <alltraps>

80106c87 <vector252>:
.globl vector252
vector252:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $252
80106c89:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c8e:	e9 94 ee ff ff       	jmp    80105b27 <alltraps>

80106c93 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $253
80106c95:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c9a:	e9 88 ee ff ff       	jmp    80105b27 <alltraps>

80106c9f <vector254>:
.globl vector254
vector254:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $254
80106ca1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ca6:	e9 7c ee ff ff       	jmp    80105b27 <alltraps>

80106cab <vector255>:
.globl vector255
vector255:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $255
80106cad:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106cb2:	e9 70 ee ff ff       	jmp    80105b27 <alltraps>
80106cb7:	66 90                	xchg   %ax,%ax
80106cb9:	66 90                	xchg   %ax,%ax
80106cbb:	66 90                	xchg   %ax,%ax
80106cbd:	66 90                	xchg   %ax,%ax
80106cbf:	90                   	nop

80106cc0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106cc0:	55                   	push   %ebp
80106cc1:	89 e5                	mov    %esp,%ebp
80106cc3:	57                   	push   %edi
80106cc4:	56                   	push   %esi
80106cc5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106cc6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106ccc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106cd2:	83 ec 1c             	sub    $0x1c,%esp
80106cd5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106cd8:	39 d3                	cmp    %edx,%ebx
80106cda:	73 49                	jae    80106d25 <deallocuvm.part.0+0x65>
80106cdc:	89 c7                	mov    %eax,%edi
80106cde:	eb 0c                	jmp    80106cec <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106ce0:	83 c0 01             	add    $0x1,%eax
80106ce3:	c1 e0 16             	shl    $0x16,%eax
80106ce6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106ce8:	39 da                	cmp    %ebx,%edx
80106cea:	76 39                	jbe    80106d25 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106cec:	89 d8                	mov    %ebx,%eax
80106cee:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106cf1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106cf4:	f6 c1 01             	test   $0x1,%cl
80106cf7:	74 e7                	je     80106ce0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106cf9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106cfb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106d01:	c1 ee 0a             	shr    $0xa,%esi
80106d04:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106d0a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106d11:	85 f6                	test   %esi,%esi
80106d13:	74 cb                	je     80106ce0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106d15:	8b 06                	mov    (%esi),%eax
80106d17:	a8 01                	test   $0x1,%al
80106d19:	75 15                	jne    80106d30 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106d1b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d21:	39 da                	cmp    %ebx,%edx
80106d23:	77 c7                	ja     80106cec <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106d25:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d2b:	5b                   	pop    %ebx
80106d2c:	5e                   	pop    %esi
80106d2d:	5f                   	pop    %edi
80106d2e:	5d                   	pop    %ebp
80106d2f:	c3                   	ret    
      if(pa == 0)
80106d30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d35:	74 25                	je     80106d5c <deallocuvm.part.0+0x9c>
      kfree(v);
80106d37:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106d3a:	05 00 00 00 80       	add    $0x80000000,%eax
80106d3f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106d42:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106d48:	50                   	push   %eax
80106d49:	e8 82 b7 ff ff       	call   801024d0 <kfree>
      *pte = 0;
80106d4e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106d54:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106d57:	83 c4 10             	add    $0x10,%esp
80106d5a:	eb 8c                	jmp    80106ce8 <deallocuvm.part.0+0x28>
        panic("kfree");
80106d5c:	83 ec 0c             	sub    $0xc,%esp
80106d5f:	68 e6 7c 10 80       	push   $0x80107ce6
80106d64:	e8 17 96 ff ff       	call   80100380 <panic>
80106d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d70 <seginit>:
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106d76:	e8 25 cc ff ff       	call   801039a0 <cpuid>
  pd[0] = size-1;
80106d7b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106d80:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106d86:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d8a:	c7 80 18 28 19 80 ff 	movl   $0xffff,-0x7fe6d7e8(%eax)
80106d91:	ff 00 00 
80106d94:	c7 80 1c 28 19 80 00 	movl   $0xcf9a00,-0x7fe6d7e4(%eax)
80106d9b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d9e:	c7 80 20 28 19 80 ff 	movl   $0xffff,-0x7fe6d7e0(%eax)
80106da5:	ff 00 00 
80106da8:	c7 80 24 28 19 80 00 	movl   $0xcf9200,-0x7fe6d7dc(%eax)
80106daf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106db2:	c7 80 28 28 19 80 ff 	movl   $0xffff,-0x7fe6d7d8(%eax)
80106db9:	ff 00 00 
80106dbc:	c7 80 2c 28 19 80 00 	movl   $0xcffa00,-0x7fe6d7d4(%eax)
80106dc3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106dc6:	c7 80 30 28 19 80 ff 	movl   $0xffff,-0x7fe6d7d0(%eax)
80106dcd:	ff 00 00 
80106dd0:	c7 80 34 28 19 80 00 	movl   $0xcff200,-0x7fe6d7cc(%eax)
80106dd7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106dda:	05 10 28 19 80       	add    $0x80192810,%eax
  pd[1] = (uint)p;
80106ddf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106de3:	c1 e8 10             	shr    $0x10,%eax
80106de6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106dea:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ded:	0f 01 10             	lgdtl  (%eax)
}
80106df0:	c9                   	leave  
80106df1:	c3                   	ret    
80106df2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e00 <walkpgdir>:
{
80106e00:	55                   	push   %ebp
80106e01:	89 e5                	mov    %esp,%ebp
80106e03:	57                   	push   %edi
80106e04:	56                   	push   %esi
80106e05:	53                   	push   %ebx
80106e06:	83 ec 0c             	sub    $0xc,%esp
80106e09:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde = &pgdir[PDX(va)];
80106e0c:	8b 55 08             	mov    0x8(%ebp),%edx
80106e0f:	89 fe                	mov    %edi,%esi
80106e11:	c1 ee 16             	shr    $0x16,%esi
80106e14:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if(*pde & PTE_P){
80106e17:	8b 1e                	mov    (%esi),%ebx
80106e19:	f6 c3 01             	test   $0x1,%bl
80106e1c:	74 22                	je     80106e40 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e1e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106e24:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  return &pgtab[PTX(va)];
80106e2a:	89 f8                	mov    %edi,%eax
}
80106e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106e2f:	c1 e8 0a             	shr    $0xa,%eax
80106e32:	25 fc 0f 00 00       	and    $0xffc,%eax
80106e37:	01 d8                	add    %ebx,%eax
}
80106e39:	5b                   	pop    %ebx
80106e3a:	5e                   	pop    %esi
80106e3b:	5f                   	pop    %edi
80106e3c:	5d                   	pop    %ebp
80106e3d:	c3                   	ret    
80106e3e:	66 90                	xchg   %ax,%ax
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106e40:	8b 45 10             	mov    0x10(%ebp),%eax
80106e43:	85 c0                	test   %eax,%eax
80106e45:	74 31                	je     80106e78 <walkpgdir+0x78>
80106e47:	e8 64 b8 ff ff       	call   801026b0 <kalloc>
80106e4c:	89 c3                	mov    %eax,%ebx
80106e4e:	85 c0                	test   %eax,%eax
80106e50:	74 26                	je     80106e78 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
80106e52:	83 ec 04             	sub    $0x4,%esp
80106e55:	68 00 10 00 00       	push   $0x1000
80106e5a:	6a 00                	push   $0x0
80106e5c:	50                   	push   %eax
80106e5d:	e8 6e d9 ff ff       	call   801047d0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e62:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e68:	83 c4 10             	add    $0x10,%esp
80106e6b:	83 c8 07             	or     $0x7,%eax
80106e6e:	89 06                	mov    %eax,(%esi)
80106e70:	eb b8                	jmp    80106e2a <walkpgdir+0x2a>
80106e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80106e78:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106e7b:	31 c0                	xor    %eax,%eax
}
80106e7d:	5b                   	pop    %ebx
80106e7e:	5e                   	pop    %esi
80106e7f:	5f                   	pop    %edi
80106e80:	5d                   	pop    %ebp
80106e81:	c3                   	ret    
80106e82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e90 <mappages>:
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	57                   	push   %edi
80106e94:	56                   	push   %esi
80106e95:	53                   	push   %ebx
80106e96:	83 ec 1c             	sub    $0x1c,%esp
80106e99:	8b 45 0c             	mov    0xc(%ebp),%eax
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106e9c:	8b 55 10             	mov    0x10(%ebp),%edx
  a = (char*)PGROUNDDOWN((uint)va);
80106e9f:	89 c3                	mov    %eax,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ea1:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
80106ea5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106eaa:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106eb0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106eb3:	8b 45 14             	mov    0x14(%ebp),%eax
80106eb6:	29 d8                	sub    %ebx,%eax
80106eb8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ebb:	eb 46                	jmp    80106f03 <mappages+0x73>
80106ebd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106ec0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ec2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106ec7:	c1 ea 0a             	shr    $0xa,%edx
80106eca:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106ed0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106ed7:	85 c0                	test   %eax,%eax
80106ed9:	74 7d                	je     80106f58 <mappages+0xc8>
    if(*pte & PTE_P)
80106edb:	f6 00 01             	testb  $0x1,(%eax)
80106ede:	0f 85 8e 00 00 00    	jne    80106f72 <mappages+0xe2>
    *pte = pa | perm | PTE_P;
80106ee4:	8b 55 18             	mov    0x18(%ebp),%edx
80106ee7:	09 f2                	or     %esi,%edx
    reference_count[pa / PGSIZE]++;
80106ee9:	c1 ee 0c             	shr    $0xc,%esi
    *pte = pa | perm | PTE_P;
80106eec:	83 ca 01             	or     $0x1,%edx
80106eef:	89 10                	mov    %edx,(%eax)
    reference_count[pa / PGSIZE]++;
80106ef1:	80 86 40 26 11 80 01 	addb   $0x1,-0x7feed9c0(%esi)
    if(a == last)
80106ef8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
80106efb:	74 6b                	je     80106f68 <mappages+0xd8>
    a += PGSIZE;
80106efd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106f03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106f06:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106f09:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106f0c:	89 d8                	mov    %ebx,%eax
80106f0e:	c1 e8 16             	shr    $0x16,%eax
80106f11:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106f14:	8b 07                	mov    (%edi),%eax
80106f16:	a8 01                	test   $0x1,%al
80106f18:	75 a6                	jne    80106ec0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106f1a:	e8 91 b7 ff ff       	call   801026b0 <kalloc>
80106f1f:	85 c0                	test   %eax,%eax
80106f21:	74 35                	je     80106f58 <mappages+0xc8>
    memset(pgtab, 0, PGSIZE);
80106f23:	83 ec 04             	sub    $0x4,%esp
80106f26:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106f29:	68 00 10 00 00       	push   $0x1000
80106f2e:	6a 00                	push   $0x0
80106f30:	50                   	push   %eax
80106f31:	e8 9a d8 ff ff       	call   801047d0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106f36:	8b 55 dc             	mov    -0x24(%ebp),%edx
  return &pgtab[PTX(va)];
80106f39:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106f3c:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106f42:	83 c8 07             	or     $0x7,%eax
80106f45:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106f47:	89 d8                	mov    %ebx,%eax
80106f49:	c1 e8 0a             	shr    $0xa,%eax
80106f4c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f51:	01 d0                	add    %edx,%eax
80106f53:	eb 86                	jmp    80106edb <mappages+0x4b>
80106f55:	8d 76 00             	lea    0x0(%esi),%esi
}
80106f58:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f60:	5b                   	pop    %ebx
80106f61:	5e                   	pop    %esi
80106f62:	5f                   	pop    %edi
80106f63:	5d                   	pop    %ebp
80106f64:	c3                   	ret    
80106f65:	8d 76 00             	lea    0x0(%esi),%esi
80106f68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f6b:	31 c0                	xor    %eax,%eax
}
80106f6d:	5b                   	pop    %ebx
80106f6e:	5e                   	pop    %esi
80106f6f:	5f                   	pop    %edi
80106f70:	5d                   	pop    %ebp
80106f71:	c3                   	ret    
      panic("remap");
80106f72:	83 ec 0c             	sub    $0xc,%esp
80106f75:	68 b0 83 10 80       	push   $0x801083b0
80106f7a:	e8 01 94 ff ff       	call   80100380 <panic>
80106f7f:	90                   	nop

80106f80 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f80:	a1 c4 a5 19 80       	mov    0x8019a5c4,%eax
80106f85:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f8a:	0f 22 d8             	mov    %eax,%cr3
}
80106f8d:	c3                   	ret    
80106f8e:	66 90                	xchg   %ax,%ax

80106f90 <switchuvm>:
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	57                   	push   %edi
80106f94:	56                   	push   %esi
80106f95:	53                   	push   %ebx
80106f96:	83 ec 1c             	sub    $0x1c,%esp
80106f99:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106f9c:	85 f6                	test   %esi,%esi
80106f9e:	0f 84 cb 00 00 00    	je     8010706f <switchuvm+0xdf>
  if(p->kstack == 0)
80106fa4:	8b 46 08             	mov    0x8(%esi),%eax
80106fa7:	85 c0                	test   %eax,%eax
80106fa9:	0f 84 da 00 00 00    	je     80107089 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106faf:	8b 46 04             	mov    0x4(%esi),%eax
80106fb2:	85 c0                	test   %eax,%eax
80106fb4:	0f 84 c2 00 00 00    	je     8010707c <switchuvm+0xec>
  pushcli();
80106fba:	e8 01 d6 ff ff       	call   801045c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106fbf:	e8 7c c9 ff ff       	call   80103940 <mycpu>
80106fc4:	89 c3                	mov    %eax,%ebx
80106fc6:	e8 75 c9 ff ff       	call   80103940 <mycpu>
80106fcb:	89 c7                	mov    %eax,%edi
80106fcd:	e8 6e c9 ff ff       	call   80103940 <mycpu>
80106fd2:	83 c7 08             	add    $0x8,%edi
80106fd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fd8:	e8 63 c9 ff ff       	call   80103940 <mycpu>
80106fdd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106fe0:	ba 67 00 00 00       	mov    $0x67,%edx
80106fe5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106fec:	83 c0 08             	add    $0x8,%eax
80106fef:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ff6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106ffb:	83 c1 08             	add    $0x8,%ecx
80106ffe:	c1 e8 18             	shr    $0x18,%eax
80107001:	c1 e9 10             	shr    $0x10,%ecx
80107004:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010700a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107010:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107015:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010701c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107021:	e8 1a c9 ff ff       	call   80103940 <mycpu>
80107026:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010702d:	e8 0e c9 ff ff       	call   80103940 <mycpu>
80107032:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107036:	8b 5e 08             	mov    0x8(%esi),%ebx
80107039:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010703f:	e8 fc c8 ff ff       	call   80103940 <mycpu>
80107044:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107047:	e8 f4 c8 ff ff       	call   80103940 <mycpu>
8010704c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107050:	b8 28 00 00 00       	mov    $0x28,%eax
80107055:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107058:	8b 46 04             	mov    0x4(%esi),%eax
8010705b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107060:	0f 22 d8             	mov    %eax,%cr3
}
80107063:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107066:	5b                   	pop    %ebx
80107067:	5e                   	pop    %esi
80107068:	5f                   	pop    %edi
80107069:	5d                   	pop    %ebp
  popcli();
8010706a:	e9 a1 d5 ff ff       	jmp    80104610 <popcli>
    panic("switchuvm: no process");
8010706f:	83 ec 0c             	sub    $0xc,%esp
80107072:	68 b6 83 10 80       	push   $0x801083b6
80107077:	e8 04 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010707c:	83 ec 0c             	sub    $0xc,%esp
8010707f:	68 e1 83 10 80       	push   $0x801083e1
80107084:	e8 f7 92 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107089:	83 ec 0c             	sub    $0xc,%esp
8010708c:	68 cc 83 10 80       	push   $0x801083cc
80107091:	e8 ea 92 ff ff       	call   80100380 <panic>
80107096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010709d:	8d 76 00             	lea    0x0(%esi),%esi

801070a0 <inituvm>:
{
801070a0:	55                   	push   %ebp
801070a1:	89 e5                	mov    %esp,%ebp
801070a3:	57                   	push   %edi
801070a4:	56                   	push   %esi
801070a5:	53                   	push   %ebx
801070a6:	83 ec 1c             	sub    $0x1c,%esp
801070a9:	8b 75 10             	mov    0x10(%ebp),%esi
801070ac:	8b 55 08             	mov    0x8(%ebp),%edx
801070af:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801070b2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801070b8:	77 50                	ja     8010710a <inituvm+0x6a>
801070ba:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  mem = kalloc();
801070bd:	e8 ee b5 ff ff       	call   801026b0 <kalloc>
  memset(mem, 0, PGSIZE);
801070c2:	83 ec 04             	sub    $0x4,%esp
801070c5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801070ca:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801070cc:	6a 00                	push   $0x0
801070ce:	50                   	push   %eax
801070cf:	e8 fc d6 ff ff       	call   801047d0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801070d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801070d7:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070dd:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801070e4:	50                   	push   %eax
801070e5:	68 00 10 00 00       	push   $0x1000
801070ea:	6a 00                	push   $0x0
801070ec:	52                   	push   %edx
801070ed:	e8 9e fd ff ff       	call   80106e90 <mappages>
  memmove(mem, init, sz);
801070f2:	89 75 10             	mov    %esi,0x10(%ebp)
801070f5:	83 c4 20             	add    $0x20,%esp
801070f8:	89 7d 0c             	mov    %edi,0xc(%ebp)
801070fb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801070fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107101:	5b                   	pop    %ebx
80107102:	5e                   	pop    %esi
80107103:	5f                   	pop    %edi
80107104:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107105:	e9 66 d7 ff ff       	jmp    80104870 <memmove>
    panic("inituvm: more than a page");
8010710a:	83 ec 0c             	sub    $0xc,%esp
8010710d:	68 f5 83 10 80       	push   $0x801083f5
80107112:	e8 69 92 ff ff       	call   80100380 <panic>
80107117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010711e:	66 90                	xchg   %ax,%ax

80107120 <loaduvm>:
{
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	57                   	push   %edi
80107124:	56                   	push   %esi
80107125:	53                   	push   %ebx
80107126:	83 ec 1c             	sub    $0x1c,%esp
80107129:	8b 45 0c             	mov    0xc(%ebp),%eax
8010712c:	8b 5d 18             	mov    0x18(%ebp),%ebx
  if((uint) addr % PGSIZE != 0)
8010712f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107134:	0f 85 c3 00 00 00    	jne    801071fd <loaduvm+0xdd>
  for(i = 0; i < sz; i += PGSIZE){
8010713a:	01 d8                	add    %ebx,%eax
8010713c:	89 df                	mov    %ebx,%edi
8010713e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107141:	8b 45 14             	mov    0x14(%ebp),%eax
80107144:	01 d8                	add    %ebx,%eax
80107146:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107149:	85 db                	test   %ebx,%ebx
8010714b:	0f 84 93 00 00 00    	je     801071e4 <loaduvm+0xc4>
80107151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107158:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010715b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010715e:	29 f8                	sub    %edi,%eax
  pde = &pgdir[PDX(va)];
80107160:	89 c2                	mov    %eax,%edx
80107162:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107165:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107168:	f6 c2 01             	test   $0x1,%dl
8010716b:	75 13                	jne    80107180 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010716d:	83 ec 0c             	sub    $0xc,%esp
80107170:	68 0f 84 10 80       	push   $0x8010840f
80107175:	e8 06 92 ff ff       	call   80100380 <panic>
8010717a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107180:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107183:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107189:	25 fc 0f 00 00       	and    $0xffc,%eax
8010718e:	8d 94 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107195:	85 d2                	test   %edx,%edx
80107197:	74 d4                	je     8010716d <loaduvm+0x4d>
    *pte &= ~PTE_W; // clear out the PTE_W flag in pte
80107199:	8b 02                	mov    (%edx),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010719b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010719e:	be 00 10 00 00       	mov    $0x1000,%esi
    *pte &= ~PTE_W; // clear out the PTE_W flag in pte
801071a3:	83 e0 f9             	and    $0xfffffff9,%eax
    *pte |= flags; // add the new flags to the pte
801071a6:	0b 45 1c             	or     0x1c(%ebp),%eax
801071a9:	89 02                	mov    %eax,(%edx)
    pa = PTE_ADDR(*pte);
801071ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801071b0:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
801071b6:	0f 46 f7             	cmovbe %edi,%esi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801071b9:	29 f9                	sub    %edi,%ecx
801071bb:	05 00 00 00 80       	add    $0x80000000,%eax
801071c0:	56                   	push   %esi
801071c1:	51                   	push   %ecx
801071c2:	50                   	push   %eax
801071c3:	ff 75 10             	push   0x10(%ebp)
801071c6:	e8 d5 a8 ff ff       	call   80101aa0 <readi>
801071cb:	83 c4 10             	add    $0x10,%esp
801071ce:	39 f0                	cmp    %esi,%eax
801071d0:	75 1e                	jne    801071f0 <loaduvm+0xd0>
  for(i = 0; i < sz; i += PGSIZE){
801071d2:	81 ef 00 10 00 00    	sub    $0x1000,%edi
801071d8:	89 d8                	mov    %ebx,%eax
801071da:	29 f8                	sub    %edi,%eax
801071dc:	39 c3                	cmp    %eax,%ebx
801071de:	0f 87 74 ff ff ff    	ja     80107158 <loaduvm+0x38>
}
801071e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801071e7:	31 c0                	xor    %eax,%eax
}
801071e9:	5b                   	pop    %ebx
801071ea:	5e                   	pop    %esi
801071eb:	5f                   	pop    %edi
801071ec:	5d                   	pop    %ebp
801071ed:	c3                   	ret    
801071ee:	66 90                	xchg   %ax,%ax
801071f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801071f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071f8:	5b                   	pop    %ebx
801071f9:	5e                   	pop    %esi
801071fa:	5f                   	pop    %edi
801071fb:	5d                   	pop    %ebp
801071fc:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801071fd:	83 ec 0c             	sub    $0xc,%esp
80107200:	68 b0 84 10 80       	push   $0x801084b0
80107205:	e8 76 91 ff ff       	call   80100380 <panic>
8010720a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107210 <allocuvm>:
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	57                   	push   %edi
80107214:	56                   	push   %esi
80107215:	53                   	push   %ebx
80107216:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107219:	8b 7d 10             	mov    0x10(%ebp),%edi
8010721c:	85 ff                	test   %edi,%edi
8010721e:	0f 88 bc 00 00 00    	js     801072e0 <allocuvm+0xd0>
  if(newsz < oldsz)
80107224:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107227:	0f 82 a3 00 00 00    	jb     801072d0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010722d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107230:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107236:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
8010723c:	39 75 10             	cmp    %esi,0x10(%ebp)
8010723f:	0f 86 8e 00 00 00    	jbe    801072d3 <allocuvm+0xc3>
80107245:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107248:	8b 7d 08             	mov    0x8(%ebp),%edi
8010724b:	eb 43                	jmp    80107290 <allocuvm+0x80>
8010724d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107250:	83 ec 04             	sub    $0x4,%esp
80107253:	68 00 10 00 00       	push   $0x1000
80107258:	6a 00                	push   $0x0
8010725a:	50                   	push   %eax
8010725b:	e8 70 d5 ff ff       	call   801047d0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107260:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107266:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
8010726d:	50                   	push   %eax
8010726e:	68 00 10 00 00       	push   $0x1000
80107273:	56                   	push   %esi
80107274:	57                   	push   %edi
80107275:	e8 16 fc ff ff       	call   80106e90 <mappages>
8010727a:	83 c4 20             	add    $0x20,%esp
8010727d:	85 c0                	test   %eax,%eax
8010727f:	78 6f                	js     801072f0 <allocuvm+0xe0>
  for(; a < newsz; a += PGSIZE){
80107281:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107287:	39 75 10             	cmp    %esi,0x10(%ebp)
8010728a:	0f 86 a0 00 00 00    	jbe    80107330 <allocuvm+0x120>
    mem = kalloc();
80107290:	e8 1b b4 ff ff       	call   801026b0 <kalloc>
80107295:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107297:	85 c0                	test   %eax,%eax
80107299:	75 b5                	jne    80107250 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010729b:	83 ec 0c             	sub    $0xc,%esp
8010729e:	68 2d 84 10 80       	push   $0x8010842d
801072a3:	e8 f8 93 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801072a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801072ab:	83 c4 10             	add    $0x10,%esp
801072ae:	39 45 10             	cmp    %eax,0x10(%ebp)
801072b1:	74 2d                	je     801072e0 <allocuvm+0xd0>
801072b3:	8b 55 10             	mov    0x10(%ebp),%edx
801072b6:	89 c1                	mov    %eax,%ecx
801072b8:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
801072bb:	31 ff                	xor    %edi,%edi
801072bd:	e8 fe f9 ff ff       	call   80106cc0 <deallocuvm.part.0>
}
801072c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072c5:	89 f8                	mov    %edi,%eax
801072c7:	5b                   	pop    %ebx
801072c8:	5e                   	pop    %esi
801072c9:	5f                   	pop    %edi
801072ca:	5d                   	pop    %ebp
801072cb:	c3                   	ret    
801072cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801072d0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801072d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072d6:	89 f8                	mov    %edi,%eax
801072d8:	5b                   	pop    %ebx
801072d9:	5e                   	pop    %esi
801072da:	5f                   	pop    %edi
801072db:	5d                   	pop    %ebp
801072dc:	c3                   	ret    
801072dd:	8d 76 00             	lea    0x0(%esi),%esi
801072e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801072e3:	31 ff                	xor    %edi,%edi
}
801072e5:	5b                   	pop    %ebx
801072e6:	89 f8                	mov    %edi,%eax
801072e8:	5e                   	pop    %esi
801072e9:	5f                   	pop    %edi
801072ea:	5d                   	pop    %ebp
801072eb:	c3                   	ret    
801072ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
801072f0:	83 ec 0c             	sub    $0xc,%esp
801072f3:	68 45 84 10 80       	push   $0x80108445
801072f8:	e8 a3 93 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801072fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80107300:	83 c4 10             	add    $0x10,%esp
80107303:	39 45 10             	cmp    %eax,0x10(%ebp)
80107306:	74 0d                	je     80107315 <allocuvm+0x105>
80107308:	89 c1                	mov    %eax,%ecx
8010730a:	8b 55 10             	mov    0x10(%ebp),%edx
8010730d:	8b 45 08             	mov    0x8(%ebp),%eax
80107310:	e8 ab f9 ff ff       	call   80106cc0 <deallocuvm.part.0>
      kfree(mem);
80107315:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107318:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010731a:	53                   	push   %ebx
8010731b:	e8 b0 b1 ff ff       	call   801024d0 <kfree>
      return 0;
80107320:	83 c4 10             	add    $0x10,%esp
}
80107323:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107326:	89 f8                	mov    %edi,%eax
80107328:	5b                   	pop    %ebx
80107329:	5e                   	pop    %esi
8010732a:	5f                   	pop    %edi
8010732b:	5d                   	pop    %ebp
8010732c:	c3                   	ret    
8010732d:	8d 76 00             	lea    0x0(%esi),%esi
80107330:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107333:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107336:	5b                   	pop    %ebx
80107337:	5e                   	pop    %esi
80107338:	89 f8                	mov    %edi,%eax
8010733a:	5f                   	pop    %edi
8010733b:	5d                   	pop    %ebp
8010733c:	c3                   	ret    
8010733d:	8d 76 00             	lea    0x0(%esi),%esi

80107340 <deallocuvm>:
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	8b 55 0c             	mov    0xc(%ebp),%edx
80107346:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107349:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010734c:	39 d1                	cmp    %edx,%ecx
8010734e:	73 10                	jae    80107360 <deallocuvm+0x20>
}
80107350:	5d                   	pop    %ebp
80107351:	e9 6a f9 ff ff       	jmp    80106cc0 <deallocuvm.part.0>
80107356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010735d:	8d 76 00             	lea    0x0(%esi),%esi
80107360:	89 d0                	mov    %edx,%eax
80107362:	5d                   	pop    %ebp
80107363:	c3                   	ret    
80107364:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010736b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010736f:	90                   	nop

80107370 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107370:	55                   	push   %ebp
80107371:	89 e5                	mov    %esp,%ebp
80107373:	57                   	push   %edi
80107374:	56                   	push   %esi
80107375:	53                   	push   %ebx
80107376:	83 ec 0c             	sub    $0xc,%esp
80107379:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010737c:	85 f6                	test   %esi,%esi
8010737e:	74 59                	je     801073d9 <freevm+0x69>
  if(newsz >= oldsz)
80107380:	31 c9                	xor    %ecx,%ecx
80107382:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107387:	89 f0                	mov    %esi,%eax
80107389:	89 f3                	mov    %esi,%ebx
8010738b:	e8 30 f9 ff ff       	call   80106cc0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107390:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107396:	eb 0f                	jmp    801073a7 <freevm+0x37>
80107398:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010739f:	90                   	nop
801073a0:	83 c3 04             	add    $0x4,%ebx
801073a3:	39 df                	cmp    %ebx,%edi
801073a5:	74 23                	je     801073ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801073a7:	8b 03                	mov    (%ebx),%eax
801073a9:	a8 01                	test   $0x1,%al
801073ab:	74 f3                	je     801073a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801073ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801073b2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801073b5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801073b8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801073bd:	50                   	push   %eax
801073be:	e8 0d b1 ff ff       	call   801024d0 <kfree>
801073c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801073c6:	39 df                	cmp    %ebx,%edi
801073c8:	75 dd                	jne    801073a7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801073ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801073cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073d0:	5b                   	pop    %ebx
801073d1:	5e                   	pop    %esi
801073d2:	5f                   	pop    %edi
801073d3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801073d4:	e9 f7 b0 ff ff       	jmp    801024d0 <kfree>
    panic("freevm: no pgdir");
801073d9:	83 ec 0c             	sub    $0xc,%esp
801073dc:	68 61 84 10 80       	push   $0x80108461
801073e1:	e8 9a 8f ff ff       	call   80100380 <panic>
801073e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ed:	8d 76 00             	lea    0x0(%esi),%esi

801073f0 <setupkvm>:
{
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
801073f3:	56                   	push   %esi
801073f4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801073f5:	e8 b6 b2 ff ff       	call   801026b0 <kalloc>
801073fa:	89 c6                	mov    %eax,%esi
801073fc:	85 c0                	test   %eax,%eax
801073fe:	74 42                	je     80107442 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107400:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107403:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107408:	68 00 10 00 00       	push   $0x1000
8010740d:	6a 00                	push   $0x0
8010740f:	50                   	push   %eax
80107410:	e8 bb d3 ff ff       	call   801047d0 <memset>
80107415:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107418:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010741b:	8b 53 08             	mov    0x8(%ebx),%edx
8010741e:	83 ec 0c             	sub    $0xc,%esp
80107421:	ff 73 0c             	push   0xc(%ebx)
80107424:	29 c2                	sub    %eax,%edx
80107426:	50                   	push   %eax
80107427:	52                   	push   %edx
80107428:	ff 33                	push   (%ebx)
8010742a:	56                   	push   %esi
8010742b:	e8 60 fa ff ff       	call   80106e90 <mappages>
80107430:	83 c4 20             	add    $0x20,%esp
80107433:	85 c0                	test   %eax,%eax
80107435:	78 19                	js     80107450 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107437:	83 c3 10             	add    $0x10,%ebx
8010743a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107440:	75 d6                	jne    80107418 <setupkvm+0x28>
}
80107442:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107445:	89 f0                	mov    %esi,%eax
80107447:	5b                   	pop    %ebx
80107448:	5e                   	pop    %esi
80107449:	5d                   	pop    %ebp
8010744a:	c3                   	ret    
8010744b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010744f:	90                   	nop
      freevm(pgdir);
80107450:	83 ec 0c             	sub    $0xc,%esp
80107453:	56                   	push   %esi
      return 0;
80107454:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107456:	e8 15 ff ff ff       	call   80107370 <freevm>
      return 0;
8010745b:	83 c4 10             	add    $0x10,%esp
}
8010745e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107461:	89 f0                	mov    %esi,%eax
80107463:	5b                   	pop    %ebx
80107464:	5e                   	pop    %esi
80107465:	5d                   	pop    %ebp
80107466:	c3                   	ret    
80107467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010746e:	66 90                	xchg   %ax,%ax

80107470 <kvmalloc>:
{
80107470:	55                   	push   %ebp
80107471:	89 e5                	mov    %esp,%ebp
80107473:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107476:	e8 75 ff ff ff       	call   801073f0 <setupkvm>
8010747b:	a3 c4 a5 19 80       	mov    %eax,0x8019a5c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107480:	05 00 00 00 80       	add    $0x80000000,%eax
80107485:	0f 22 d8             	mov    %eax,%cr3
}
80107488:	c9                   	leave  
80107489:	c3                   	ret    
8010748a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107490 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	83 ec 08             	sub    $0x8,%esp
80107496:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107499:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010749c:	89 c1                	mov    %eax,%ecx
8010749e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801074a1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801074a4:	f6 c2 01             	test   $0x1,%dl
801074a7:	75 17                	jne    801074c0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801074a9:	83 ec 0c             	sub    $0xc,%esp
801074ac:	68 72 84 10 80       	push   $0x80108472
801074b1:	e8 ca 8e ff ff       	call   80100380 <panic>
801074b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074bd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801074c0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074c3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801074c9:	25 fc 0f 00 00       	and    $0xffc,%eax
801074ce:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801074d5:	85 c0                	test   %eax,%eax
801074d7:	74 d0                	je     801074a9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801074d9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801074dc:	c9                   	leave  
801074dd:	c3                   	ret    
801074de:	66 90                	xchg   %ax,%ax

801074e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801074e0:	55                   	push   %ebp
801074e1:	89 e5                	mov    %esp,%ebp
801074e3:	57                   	push   %edi
801074e4:	56                   	push   %esi
801074e5:	53                   	push   %ebx
801074e6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  // char *mem;

  if((d = setupkvm()) == 0)
801074e9:	e8 02 ff ff ff       	call   801073f0 <setupkvm>
801074ee:	89 c3                	mov    %eax,%ebx
801074f0:	85 c0                	test   %eax,%eax
801074f2:	0f 84 a4 00 00 00    	je     8010759c <copyuvm+0xbc>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801074f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801074fb:	85 c0                	test   %eax,%eax
801074fd:	0f 84 99 00 00 00    	je     8010759c <copyuvm+0xbc>
    //   goto bad;
    // }
    mappages(d, (void *)i, PGSIZE, pa, flags);
    // pte_t *child_pte = walkpgdir(d, (void *)i, 1);
    // *child_pte = pa | flags | PTE_P;
    lcr3(V2P(d)); // tlb flush cr3
80107503:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  for(i = 0; i < sz; i += PGSIZE){
80107509:	31 ff                	xor    %edi,%edi
    lcr3(V2P(d)); // tlb flush cr3
8010750b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // reference_count[pa / PGSIZE]++;

    *pte &= ~PTE_W; // make parent also not readable
    lcr3(V2P(pgdir)); // tlb flush parent pgdir 
8010750e:	8b 45 08             	mov    0x8(%ebp),%eax
80107511:	05 00 00 00 80       	add    $0x80000000,%eax
80107516:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*pde & PTE_P){
80107520:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107523:	89 f8                	mov    %edi,%eax
80107525:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107528:	8b 04 82             	mov    (%edx,%eax,4),%eax
8010752b:	a8 01                	test   $0x1,%al
8010752d:	75 11                	jne    80107540 <copyuvm+0x60>
      panic("copyuvm: pte should exist");
8010752f:	83 ec 0c             	sub    $0xc,%esp
80107532:	68 7c 84 10 80       	push   $0x8010847c
80107537:	e8 44 8e ff ff       	call   80100380 <panic>
8010753c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107540:	89 fa                	mov    %edi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107542:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107547:	c1 ea 0a             	shr    $0xa,%edx
8010754a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107550:	8d b4 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%esi
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107557:	85 f6                	test   %esi,%esi
80107559:	74 d4                	je     8010752f <copyuvm+0x4f>
    if(!(*pte & PTE_P))
8010755b:	8b 06                	mov    (%esi),%eax
8010755d:	a8 01                	test   $0x1,%al
8010755f:	74 45                	je     801075a6 <copyuvm+0xc6>
    flags &= ~PTE_W; // make child not readable
80107561:	89 c1                	mov    %eax,%ecx
    mappages(d, (void *)i, PGSIZE, pa, flags);
80107563:	83 ec 0c             	sub    $0xc,%esp
    pa = PTE_ADDR(*pte);
80107566:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    flags &= ~PTE_W; // make child not readable
8010756b:	81 e1 fd 0f 00 00    	and    $0xffd,%ecx
    mappages(d, (void *)i, PGSIZE, pa, flags);
80107571:	51                   	push   %ecx
80107572:	50                   	push   %eax
80107573:	68 00 10 00 00       	push   $0x1000
80107578:	57                   	push   %edi
80107579:	53                   	push   %ebx
8010757a:	e8 11 f9 ff ff       	call   80106e90 <mappages>
8010757f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107582:	0f 22 d8             	mov    %eax,%cr3
    *pte &= ~PTE_W; // make parent also not readable
80107585:	83 26 fd             	andl   $0xfffffffd,(%esi)
80107588:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010758b:	0f 22 d8             	mov    %eax,%cr3
  for(i = 0; i < sz; i += PGSIZE){
8010758e:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107594:	83 c4 20             	add    $0x20,%esp
80107597:	39 7d 0c             	cmp    %edi,0xc(%ebp)
8010759a:	77 84                	ja     80107520 <copyuvm+0x40>
  return d;

// bad:
//   freevm(d);
//   return 0;
}
8010759c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010759f:	89 d8                	mov    %ebx,%eax
801075a1:	5b                   	pop    %ebx
801075a2:	5e                   	pop    %esi
801075a3:	5f                   	pop    %edi
801075a4:	5d                   	pop    %ebp
801075a5:	c3                   	ret    
      panic("copyuvm: page not present");
801075a6:	83 ec 0c             	sub    $0xc,%esp
801075a9:	68 96 84 10 80       	push   $0x80108496
801075ae:	e8 cd 8d ff ff       	call   80100380 <panic>
801075b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075c0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801075c0:	55                   	push   %ebp
801075c1:	89 e5                	mov    %esp,%ebp
801075c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801075c6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801075c9:	89 c1                	mov    %eax,%ecx
801075cb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801075ce:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801075d1:	f6 c2 01             	test   $0x1,%dl
801075d4:	0f 84 00 01 00 00    	je     801076da <uva2ka.cold>
  return &pgtab[PTX(va)];
801075da:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075dd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801075e3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801075e4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801075e9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801075f0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801075f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801075f7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801075fa:	05 00 00 00 80       	add    $0x80000000,%eax
801075ff:	83 fa 05             	cmp    $0x5,%edx
80107602:	ba 00 00 00 00       	mov    $0x0,%edx
80107607:	0f 45 c2             	cmovne %edx,%eax
}
8010760a:	c3                   	ret    
8010760b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010760f:	90                   	nop

80107610 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107610:	55                   	push   %ebp
80107611:	89 e5                	mov    %esp,%ebp
80107613:	57                   	push   %edi
80107614:	56                   	push   %esi
80107615:	53                   	push   %ebx
80107616:	83 ec 0c             	sub    $0xc,%esp
80107619:	8b 75 14             	mov    0x14(%ebp),%esi
8010761c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010761f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107622:	85 f6                	test   %esi,%esi
80107624:	75 51                	jne    80107677 <copyout+0x67>
80107626:	e9 a5 00 00 00       	jmp    801076d0 <copyout+0xc0>
8010762b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010762f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107630:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107636:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010763c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107642:	74 75                	je     801076b9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107644:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107646:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107649:	29 c3                	sub    %eax,%ebx
8010764b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107651:	39 f3                	cmp    %esi,%ebx
80107653:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107656:	29 f8                	sub    %edi,%eax
80107658:	83 ec 04             	sub    $0x4,%esp
8010765b:	01 c1                	add    %eax,%ecx
8010765d:	53                   	push   %ebx
8010765e:	52                   	push   %edx
8010765f:	51                   	push   %ecx
80107660:	e8 0b d2 ff ff       	call   80104870 <memmove>
    len -= n;
    buf += n;
80107665:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107668:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010766e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107671:	01 da                	add    %ebx,%edx
  while(len > 0){
80107673:	29 de                	sub    %ebx,%esi
80107675:	74 59                	je     801076d0 <copyout+0xc0>
  if(*pde & PTE_P){
80107677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010767a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010767c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010767e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107681:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107687:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010768a:	f6 c1 01             	test   $0x1,%cl
8010768d:	0f 84 4e 00 00 00    	je     801076e1 <copyout.cold>
  return &pgtab[PTX(va)];
80107693:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107695:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010769b:	c1 eb 0c             	shr    $0xc,%ebx
8010769e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801076a4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801076ab:	89 d9                	mov    %ebx,%ecx
801076ad:	83 e1 05             	and    $0x5,%ecx
801076b0:	83 f9 05             	cmp    $0x5,%ecx
801076b3:	0f 84 77 ff ff ff    	je     80107630 <copyout+0x20>
  }
  return 0;
}
801076b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801076bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801076c1:	5b                   	pop    %ebx
801076c2:	5e                   	pop    %esi
801076c3:	5f                   	pop    %edi
801076c4:	5d                   	pop    %ebp
801076c5:	c3                   	ret    
801076c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076cd:	8d 76 00             	lea    0x0(%esi),%esi
801076d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801076d3:	31 c0                	xor    %eax,%eax
}
801076d5:	5b                   	pop    %ebx
801076d6:	5e                   	pop    %esi
801076d7:	5f                   	pop    %edi
801076d8:	5d                   	pop    %ebp
801076d9:	c3                   	ret    

801076da <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801076da:	a1 00 00 00 00       	mov    0x0,%eax
801076df:	0f 0b                	ud2    

801076e1 <copyout.cold>:
801076e1:	a1 00 00 00 00       	mov    0x0,%eax
801076e6:	0f 0b                	ud2    
801076e8:	66 90                	xchg   %ax,%ax
801076ea:	66 90                	xchg   %ax,%ax
801076ec:	66 90                	xchg   %ax,%ax
801076ee:	66 90                	xchg   %ax,%ax

801076f0 <wmap>:
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"

uint wmap(uint addr, int length, int flags, int fd) {
801076f0:	55                   	push   %ebp
801076f1:	89 e5                	mov    %esp,%ebp
801076f3:	57                   	push   %edi
801076f4:	56                   	push   %esi
801076f5:	53                   	push   %ebx
801076f6:	83 ec 1c             	sub    $0x1c,%esp
    struct proc* proc = myproc();
801076f9:	e8 c2 c2 ff ff       	call   801039c0 <myproc>
    if(!proc) return FAILED; // myproc() failed
801076fe:	85 c0                	test   %eax,%eax
80107700:	74 70                	je     80107772 <wmap+0x82>

    // check if each virtual page in the address range is not already mapped to a physical page
    uint curr_addr = addr;
    pte_t *pte;
    while(curr_addr < addr + length) {
80107702:	8b 7d 0c             	mov    0xc(%ebp),%edi
80107705:	89 c3                	mov    %eax,%ebx
80107707:	03 7d 08             	add    0x8(%ebp),%edi
8010770a:	39 7d 08             	cmp    %edi,0x8(%ebp)
8010770d:	73 2d                	jae    8010773c <wmap+0x4c>
8010770f:	8b 75 08             	mov    0x8(%ebp),%esi
80107712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        pte = walkpgdir(proc->pgdir, (void *)curr_addr, 0);
80107718:	83 ec 04             	sub    $0x4,%esp
8010771b:	6a 00                	push   $0x0
8010771d:	56                   	push   %esi
8010771e:	ff 73 04             	push   0x4(%ebx)
80107721:	e8 da f6 ff ff       	call   80106e00 <walkpgdir>
        if(pte != 0 && (*pte & PTE_P) != 0) return FAILED; // pte for the vpn contains a ppn (already mapped)
80107726:	83 c4 10             	add    $0x10,%esp
80107729:	85 c0                	test   %eax,%eax
8010772b:	74 05                	je     80107732 <wmap+0x42>
8010772d:	f6 00 01             	testb  $0x1,(%eax)
80107730:	75 40                	jne    80107772 <wmap+0x82>
        curr_addr += PGSIZE;
80107732:	81 c6 00 10 00 00    	add    $0x1000,%esi
    while(curr_addr < addr + length) {
80107738:	39 fe                	cmp    %edi,%esi
8010773a:	72 dc                	jb     80107718 <wmap+0x28>
8010773c:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010773f:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80107745:	8d b3 c0 00 00 00    	lea    0xc0(%ebx),%esi
8010774b:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010774e:	eb 0f                	jmp    8010775f <wmap+0x6f>

    // check for overlapping maps
    struct wmappings *mappings = &proc->mappings;
    for(int i = 0; i < MAX_WMMAP_INFO; i++) {
        if(mappings->length[i] > 0) { // mapping exists
            if(addr <= mappings->addr[i] && addr + length > mappings->addr[i]) return FAILED;
80107750:	39 f9                	cmp    %edi,%ecx
80107752:	72 1e                	jb     80107772 <wmap+0x82>
            if(addr >= mappings->addr[i] && addr < mappings->addr[i] + mappings->length[i]) return FAILED;
80107754:	39 d9                	cmp    %ebx,%ecx
80107756:	74 14                	je     8010776c <wmap+0x7c>
    for(int i = 0; i < MAX_WMMAP_INFO; i++) {
80107758:	83 c0 04             	add    $0x4,%eax
8010775b:	39 c6                	cmp    %eax,%esi
8010775d:	74 21                	je     80107780 <wmap+0x90>
        if(mappings->length[i] > 0) { // mapping exists
8010775f:	8b 50 40             	mov    0x40(%eax),%edx
80107762:	85 d2                	test   %edx,%edx
80107764:	7e f2                	jle    80107758 <wmap+0x68>
            if(addr <= mappings->addr[i] && addr + length > mappings->addr[i]) return FAILED;
80107766:	8b 08                	mov    (%eax),%ecx
80107768:	39 d9                	cmp    %ebx,%ecx
8010776a:	73 e4                	jae    80107750 <wmap+0x60>
            if(addr >= mappings->addr[i] && addr < mappings->addr[i] + mappings->length[i]) return FAILED;
8010776c:	01 ca                	add    %ecx,%edx
8010776e:	39 da                	cmp    %ebx,%edx
80107770:	76 e6                	jbe    80107758 <wmap+0x68>
        }
    }
    return addr;


}
80107772:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(!proc) return FAILED; // myproc() failed
80107775:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010777a:	5b                   	pop    %ebx
8010777b:	5e                   	pop    %esi
8010777c:	5f                   	pop    %edi
8010777d:	5d                   	pop    %ebp
8010777e:	c3                   	ret    
8010777f:	90                   	nop
    for(int i = 0; i < MAX_WMMAP_INFO; i++) {
80107780:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80107783:	31 c0                	xor    %eax,%eax
80107785:	8d 76 00             	lea    0x0(%esi),%esi
        if(mappings->length[i] == 0) { // empty slot is found
80107788:	8b 94 83 c0 00 00 00 	mov    0xc0(%ebx,%eax,4),%edx
8010778f:	85 d2                	test   %edx,%edx
80107791:	74 1d                	je     801077b0 <wmap+0xc0>
    for(int i = 0; i < MAX_WMMAP_INFO; i++) {
80107793:	83 c0 01             	add    $0x1,%eax
80107796:	83 f8 10             	cmp    $0x10,%eax
80107799:	75 ed                	jne    80107788 <wmap+0x98>
                        break;
8010779b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010779e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077a1:	5b                   	pop    %ebx
801077a2:	5e                   	pop    %esi
801077a3:	5f                   	pop    %edi
801077a4:	5d                   	pop    %ebp
801077a5:	c3                   	ret    
801077a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077ad:	8d 76 00             	lea    0x0(%esi),%esi
            mappings->total_mmaps++;
801077b0:	8d 14 83             	lea    (%ebx,%eax,4),%edx
            mappings->addr[i] = addr;
801077b3:	8b 45 08             	mov    0x8(%ebp),%eax
            mappings->total_mmaps++;
801077b6:	83 43 7c 01          	addl   $0x1,0x7c(%ebx)
            mappings->n_loaded_pages[i] = 0;
801077ba:	c7 82 00 01 00 00 00 	movl   $0x0,0x100(%edx)
801077c1:	00 00 00 
            mappings->addr[i] = addr;
801077c4:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
            mappings->length[i] = length;
801077ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801077cd:	89 82 c0 00 00 00    	mov    %eax,0xc0(%edx)
            mappings->flags[i] = flags;
801077d3:	8b 45 10             	mov    0x10(%ebp),%eax
            if((flags & MAP_ANONYMOUS) == 0) { // file-backed
801077d6:	89 c7                	mov    %eax,%edi
            mappings->flags[i] = flags;
801077d8:	89 82 40 01 00 00    	mov    %eax,0x140(%edx)
            if((flags & MAP_ANONYMOUS) == 0) { // file-backed
801077de:	83 e7 04             	and    $0x4,%edi
801077e1:	75 b8                	jne    8010779b <wmap+0xab>
801077e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077e7:	90                   	nop
                    if(proc->ofile[j] == 0) { // empty slot is found
801077e8:	8b 44 bb 28          	mov    0x28(%ebx,%edi,4),%eax
801077ec:	85 c0                	test   %eax,%eax
801077ee:	74 0a                	je     801077fa <wmap+0x10a>
                for(int j = 0; j < NOFILE; j++) {
801077f0:	83 c7 01             	add    $0x1,%edi
801077f3:	83 ff 10             	cmp    $0x10,%edi
801077f6:	75 f0                	jne    801077e8 <wmap+0xf8>
801077f8:	eb a1                	jmp    8010779b <wmap+0xab>
                        proc->ofile[j] = filedup(proc->ofile[fd]);
801077fa:	8b 45 14             	mov    0x14(%ebp),%eax
801077fd:	83 ec 0c             	sub    $0xc,%esp
80107800:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107803:	ff 74 83 28          	push   0x28(%ebx,%eax,4)
80107807:	e8 a4 96 ff ff       	call   80100eb0 <filedup>
                        mappings->fd[i] = j;
8010780c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
                        break;
8010780f:	83 c4 10             	add    $0x10,%esp
                        proc->ofile[j] = filedup(proc->ofile[fd]);
80107812:	89 44 bb 28          	mov    %eax,0x28(%ebx,%edi,4)
                        mappings->fd[i] = j;
80107816:	89 ba 80 01 00 00    	mov    %edi,0x180(%edx)
                        break;
8010781c:	e9 7a ff ff ff       	jmp    8010779b <wmap+0xab>
80107821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010782f:	90                   	nop

80107830 <wunmap>:

int wunmap(uint addr) {
80107830:	55                   	push   %ebp
80107831:	89 e5                	mov    %esp,%ebp
80107833:	57                   	push   %edi
80107834:	56                   	push   %esi
80107835:	53                   	push   %ebx
80107836:	83 ec 2c             	sub    $0x2c,%esp
80107839:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc* proc = myproc();
8010783c:	e8 7f c1 ff ff       	call   801039c0 <myproc>
    if(!proc) return FAILED; // myproc() failed
80107841:	85 c0                	test   %eax,%eax
80107843:	0f 84 61 01 00 00    	je     801079aa <wunmap+0x17a>
80107849:	89 c7                	mov    %eax,%edi
    struct wmappings *mappings = &proc->mappings;
    for(int i = 0; i < MAX_WMMAP_INFO; i++) {
8010784b:	31 c0                	xor    %eax,%eax
8010784d:	8d 76 00             	lea    0x0(%esi),%esi
        if(mappings->addr[i] == addr) { // mapping found
80107850:	39 9c 87 80 00 00 00 	cmp    %ebx,0x80(%edi,%eax,4)
80107857:	74 17                	je     80107870 <wunmap+0x40>
    for(int i = 0; i < MAX_WMMAP_INFO; i++) {
80107859:	83 c0 01             	add    $0x1,%eax
8010785c:	83 f8 10             	cmp    $0x10,%eax
8010785f:	75 ef                	jne    80107850 <wunmap+0x20>
            mappings->n_loaded_pages[i] = 0;
            mappings->flags[i] = 0;
            break;
        }
    }
    return SUCCESS;
80107861:	31 c0                	xor    %eax,%eax
}
80107863:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107866:	5b                   	pop    %ebx
80107867:	5e                   	pop    %esi
80107868:	5f                   	pop    %edi
80107869:	5d                   	pop    %ebp
8010786a:	c3                   	ret    
8010786b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010786f:	90                   	nop
            int length = mappings->length[i];
80107870:	8d 04 87             	lea    (%edi,%eax,4),%eax
80107873:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
            while(curr_addr < addr + length) {
80107879:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010787e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107881:	8b 80 c0 00 00 00    	mov    0xc0(%eax),%eax
80107887:	01 d8                	add    %ebx,%eax
80107889:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010788c:	39 c3                	cmp    %eax,%ebx
8010788e:	0f 83 7d 00 00 00    	jae    80107911 <wunmap+0xe1>
80107894:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107897:	89 cb                	mov    %ecx,%ebx
80107899:	eb 07                	jmp    801078a2 <wunmap+0x72>
8010789b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010789f:	90                   	nop
801078a0:	89 c6                	mov    %eax,%esi
                pte = walkpgdir(proc->pgdir, (void *)curr_addr, 0);
801078a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078a5:	83 ec 04             	sub    $0x4,%esp
801078a8:	8d be 00 f0 ff ff    	lea    -0x1000(%esi),%edi
801078ae:	6a 00                	push   $0x0
801078b0:	57                   	push   %edi
801078b1:	ff 70 04             	push   0x4(%eax)
801078b4:	e8 47 f5 ff ff       	call   80106e00 <walkpgdir>
                if(pte == 0 || (*pte & PTE_P) == 0) { // page table doesn't exist or pte doesn't contiain ppn
801078b9:	83 c4 10             	add    $0x10,%esp
                pte = walkpgdir(proc->pgdir, (void *)curr_addr, 0);
801078bc:	89 c2                	mov    %eax,%edx
                if(pte == 0 || (*pte & PTE_P) == 0) { // page table doesn't exist or pte doesn't contiain ppn
801078be:	85 c0                	test   %eax,%eax
801078c0:	74 3b                	je     801078fd <wunmap+0xcd>
801078c2:	8b 00                	mov    (%eax),%eax
801078c4:	a8 01                	test   $0x1,%al
801078c6:	74 35                	je     801078fd <wunmap+0xcd>
                if((mappings->flags[i] & MAP_ANONYMOUS) == 0 && (mappings->flags[i] & MAP_SHARED) != 0) { // check if file-backed
801078c8:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801078cb:	8b 89 40 01 00 00    	mov    0x140(%ecx),%ecx
801078d1:	f6 c1 04             	test   $0x4,%cl
801078d4:	75 05                	jne    801078db <wunmap+0xab>
801078d6:	83 e1 02             	and    $0x2,%ecx
801078d9:	75 75                	jne    80107950 <wunmap+0x120>
                uint physical_addr = PTE_ADDR(*pte); // get physical addr of page
801078db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
                kfree(P2V(physical_addr)); // free physical page
801078e0:	83 ec 0c             	sub    $0xc,%esp
801078e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801078e6:	05 00 00 00 80       	add    $0x80000000,%eax
801078eb:	50                   	push   %eax
801078ec:	e8 df ab ff ff       	call   801024d0 <kfree>
                *pte = 0; // clear the pte
801078f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801078f4:	83 c4 10             	add    $0x10,%esp
801078f7:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
            while(curr_addr < addr + length) {
801078fd:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
80107903:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107909:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010790c:	77 92                	ja     801078a0 <wunmap+0x70>
8010790e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
            mappings->addr[i] = 0;
80107911:	8b 45 d8             	mov    -0x28(%ebp),%eax
            mappings->total_mmaps--;
80107914:	83 6f 7c 01          	subl   $0x1,0x7c(%edi)
            mappings->addr[i] = 0;
80107918:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010791f:	00 00 00 
            mappings->length[i] = 0;
80107922:	c7 80 c0 00 00 00 00 	movl   $0x0,0xc0(%eax)
80107929:	00 00 00 
            mappings->n_loaded_pages[i] = 0;
8010792c:	c7 80 00 01 00 00 00 	movl   $0x0,0x100(%eax)
80107933:	00 00 00 
            mappings->flags[i] = 0;
80107936:	c7 80 40 01 00 00 00 	movl   $0x0,0x140(%eax)
8010793d:	00 00 00 
}
80107940:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return SUCCESS;
80107943:	31 c0                	xor    %eax,%eax
}
80107945:	5b                   	pop    %ebx
80107946:	5e                   	pop    %esi
80107947:	5f                   	pop    %edi
80107948:	5d                   	pop    %ebp
80107949:	c3                   	ret    
8010794a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                    struct file *file = proc->ofile[mappings->fd[i]];
80107950:	8b 45 d8             	mov    -0x28(%ebp),%eax
                    struct inode *inode = file->ip;
80107953:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107956:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                    struct file *file = proc->ofile[mappings->fd[i]];
80107959:	8b 80 80 01 00 00    	mov    0x180(%eax),%eax
                    struct inode *inode = file->ip;
8010795f:	8b 44 81 28          	mov    0x28(%ecx,%eax,4),%eax
80107963:	8b 40 10             	mov    0x10(%eax),%eax
80107966:	89 45 dc             	mov    %eax,-0x24(%ebp)
                    begin_op();
80107969:	e8 22 b4 ff ff       	call   80102d90 <begin_op>
                    ilock(inode);
8010796e:	83 ec 0c             	sub    $0xc,%esp
80107971:	ff 75 dc             	push   -0x24(%ebp)
80107974:	e8 17 9e ff ff       	call   80101790 <ilock>
                    writei(inode, (char *)curr_addr, offset, PGSIZE);
80107979:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010797f:	68 00 10 00 00       	push   $0x1000
80107984:	50                   	push   %eax
80107985:	57                   	push   %edi
80107986:	8b 7d dc             	mov    -0x24(%ebp),%edi
80107989:	57                   	push   %edi
8010798a:	e8 11 a2 ff ff       	call   80101ba0 <writei>
                    iunlock(inode);
8010798f:	83 c4 14             	add    $0x14,%esp
80107992:	57                   	push   %edi
80107993:	e8 d8 9e ff ff       	call   80101870 <iunlock>
                    end_op();
80107998:	e8 63 b4 ff ff       	call   80102e00 <end_op>
                uint physical_addr = PTE_ADDR(*pte); // get physical addr of page
8010799d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801079a0:	83 c4 10             	add    $0x10,%esp
801079a3:	8b 02                	mov    (%edx),%eax
801079a5:	e9 31 ff ff ff       	jmp    801078db <wunmap+0xab>
    if(!proc) return FAILED; // myproc() failed
801079aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079af:	e9 af fe ff ff       	jmp    80107863 <wunmap+0x33>
801079b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079bf:	90                   	nop

801079c0 <va2pa>:

uint va2pa(uint va) {
801079c0:	55                   	push   %ebp
801079c1:	89 e5                	mov    %esp,%ebp
801079c3:	53                   	push   %ebx
801079c4:	83 ec 04             	sub    $0x4,%esp
801079c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc* proc = myproc();
801079ca:	e8 f1 bf ff ff       	call   801039c0 <myproc>
    if(!proc) return FAILED; // myproc() failed
801079cf:	85 c0                	test   %eax,%eax
801079d1:	74 2d                	je     80107a00 <va2pa+0x40>
    pte_t *pte = walkpgdir(proc->pgdir, (void *)va, 0);
801079d3:	83 ec 04             	sub    $0x4,%esp
801079d6:	6a 00                	push   $0x0
801079d8:	53                   	push   %ebx
801079d9:	ff 70 04             	push   0x4(%eax)
801079dc:	e8 1f f4 ff ff       	call   80106e00 <walkpgdir>
    if(pte == 0 || (*pte & PTE_P) == 0) return FAILED; // page table doesn't exist or pte doesn't contiain ppn
801079e1:	83 c4 10             	add    $0x10,%esp
801079e4:	85 c0                	test   %eax,%eax
801079e6:	74 18                	je     80107a00 <va2pa+0x40>
801079e8:	8b 00                	mov    (%eax),%eax
801079ea:	a8 01                	test   $0x1,%al
801079ec:	74 12                	je     80107a00 <va2pa+0x40>

    uint physical_addr = PTE_ADDR(*pte); // get physical addr of page
    uint offset = va & ((1 << 12) - 1);
801079ee:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    uint physical_addr = PTE_ADDR(*pte); // get physical addr of page
801079f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    return physical_addr + offset;
801079f9:	09 d8                	or     %ebx,%eax
}
801079fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801079fe:	c9                   	leave  
801079ff:	c3                   	ret    
80107a00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    if(!proc) return FAILED; // myproc() failed
80107a03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a08:	c9                   	leave  
80107a09:	c3                   	ret    
80107a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107a10 <getwmapinfo>:

int getwmapinfo(struct wmapinfo *wminfo) {
80107a10:	55                   	push   %ebp
80107a11:	89 e5                	mov    %esp,%ebp
80107a13:	53                   	push   %ebx
80107a14:	83 ec 04             	sub    $0x4,%esp
80107a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc* proc = myproc();
80107a1a:	e8 a1 bf ff ff       	call   801039c0 <myproc>
    if(!proc) return FAILED; // myproc() failed
80107a1f:	85 c0                	test   %eax,%eax
80107a21:	74 40                	je     80107a63 <getwmapinfo+0x53>
80107a23:	89 c2                	mov    %eax,%edx
    struct wmappings *mappings = &proc->mappings;
    wminfo->total_mmaps = mappings->total_mmaps;
80107a25:	8b 40 7c             	mov    0x7c(%eax),%eax
80107a28:	89 03                	mov    %eax,(%ebx)
    for(int i = 0; i < MAX_WMMAP_INFO; i++) {
80107a2a:	31 c0                	xor    %eax,%eax
80107a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        wminfo->addr[i] = mappings->addr[i];
80107a30:	8b 8c 82 80 00 00 00 	mov    0x80(%edx,%eax,4),%ecx
80107a37:	89 4c 83 04          	mov    %ecx,0x4(%ebx,%eax,4)
        wminfo->length[i] = mappings->length[i];
80107a3b:	8b 8c 82 c0 00 00 00 	mov    0xc0(%edx,%eax,4),%ecx
80107a42:	89 4c 83 44          	mov    %ecx,0x44(%ebx,%eax,4)
        wminfo->n_loaded_pages[i] = mappings->n_loaded_pages[i];
80107a46:	8b 8c 82 00 01 00 00 	mov    0x100(%edx,%eax,4),%ecx
80107a4d:	89 8c 83 84 00 00 00 	mov    %ecx,0x84(%ebx,%eax,4)
    for(int i = 0; i < MAX_WMMAP_INFO; i++) {
80107a54:	83 c0 01             	add    $0x1,%eax
80107a57:	83 f8 10             	cmp    $0x10,%eax
80107a5a:	75 d4                	jne    80107a30 <getwmapinfo+0x20>
    }
    return SUCCESS;
80107a5c:	31 c0                	xor    %eax,%eax
80107a5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107a61:	c9                   	leave  
80107a62:	c3                   	ret    
    if(!proc) return FAILED; // myproc() failed
80107a63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a68:	eb f4                	jmp    80107a5e <getwmapinfo+0x4e>
