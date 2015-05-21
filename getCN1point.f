      parameter(np=9,nlo=360,nla=180)      
      dimension vp(np,nla,nlo),vs(np,nla,nlo),rho(np,nla,nlo)
      dimension bnd(np,nla,nlo)
        
      open(51,file='/home/junly/app/crust1.0/crust1.vp')
      open(52,file='/home/junly/app/crust1.0/crust1.vs')
      open(53,file='/home/junly/app/crust1.0/crust1.rho')
      open(54,file='/home/junly/app/crust1.0/crust1.bnds')

      print*,' .... reading all maps ... ' 

      do j=1,nla
         do i=1,nlo
            read(51,*)(vp(k,j,i),k=1,np)
            read(52,*)(vs(k,j,i),k=1,np)
            read(53,*)(rho(k,j,i),k=1,np)
            read(54,*)(bnd(k,j,i),k=1,np)
         enddo
      enddo
      close(51)
      close(52)
      close(53)
      close(54)
 1    continue
      print*,'enter center lat, long of desired tile (q to quit)' 
      read(*,*,err=99)flat,flon
c make sure longitudes go from -180 to 180
      if(flon.gt.180.)flon=flon-360.
      if(flon.lt.-180.)flon=flon+360.

      ilat=90.-flat+1
      ilon=180.+flon+1
      print 102,'ilat,ilon,crustal type: ',ilat,ilon
 102  format(a,2i4) 
      print*,'topography: ',bnd(1,ilat,ilon)
      print*,' layers: vp,vs,rho,bottom'
 103  format(4f7.2)
      do i=1,np-1
         print 103,vp(i,ilat,ilon),vs(i,ilat,ilon),rho(i,ilat,ilon),
     +bnd(i+1,ilat,ilon)
      enddo
      print 104,' pn,sn,rho-mantle: ',vp(9,ilat,ilon),
     +vs(9,ilat,ilon),rho(9,ilat,ilon)
 104  format(a,3f7.2)
      goto 1
 99   continue

c   write the data into file
 108  format(4f7.2)
       open(112,file='crust.dat')
       write(112,108), abs(bnd(2,ilat,ilon)),
     +vs(1,ilat,ilon),vp(1,ilat,ilon), rho(1,ilat,ilon) 
      do i=2,np-1
      write(112,108),abs(bnd(i+1,ilat,ilon)-bnd(i,ilat,ilon)),
     +vs(i,ilat,ilon),vp(i,ilat,ilon), rho(i,ilat,ilon)
      enddo
       write(112,'(A7,3f7.2)'),'0',
     +  vs(9,ilat,ilon),vp(9,ilat,ilon), rho(9,ilat,ilon)
       close(112)
       
c   chose the data using in the fk,that every element is not ZERO
      open(113,file='model.dat')
      if(vs(1,ilat,ilon)/=0 .AND. vp(1,ilat,ilon)/=0 .AND. 
     +rho(1,ilat,ilon)/=0 .AND. 
     +abs(bnd(2,ilat,ilon)-bnd(1,ilat,ilon))/=0 ) then
        write(113,108),abs(bnd(2,ilat,ilon)-bnd(1,ilat,ilon)),
     +     vs(1,ilat,ilon),vp(1,ilat,ilon), rho(1,ilat,ilon)
      endif
      do i=2,np-1
      if(vs(i,ilat,ilon)/=0 .AND. vp(i,ilat,ilon)/=0 .AND. 
     +rho(i,ilat,ilon)/=0 .AND. 
     +abs(bnd(i+1,ilat,ilon)-bnd(i,ilat,ilon))/=0 ) then
        write(113,108),abs(bnd(i+1,ilat,ilon)-bnd(i,ilat,ilon)),
     +     vs(i,ilat,ilon),vp(i,ilat,ilon), rho(i,ilat,ilon)
      endif
      enddo 
      write(113,'(A7,3f7.2)'),'0',
     +  vs(9,ilat,ilon),vp(9,ilat,ilon), rho(9,ilat,ilon)
      close(113)
      end
