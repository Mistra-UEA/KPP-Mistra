!--------------------------------------------------------------
!
! BLAS/LAPACK-like subroutines used by the integration algorithms
! It is recommended to replace them by calls to the optimized
!      BLAS/LAPACK library for your machine
!
!  (C) Adrian Sandu, Aug. 2004
!      Virginia Polytechnic Institute and State University
!--------------------------------------------------------------


!--------------------------------------------------------------
      SUBROUTINE WCOPY(N,X,incX,Y,incY)
!--------------------------------------------------------------
!     copies a vector, x, to a vector, y:  y <- x
!     only for incX=incY=1
!     after BLAS
!     replace this by the function from the optimized BLAS implementation:
!         CALL  SCOPY(N,X,1,Y,1)   or   CALL  DCOPY(N,X,1,Y,1)
!--------------------------------------------------------------

      INTEGER i,incX,incY,M,MP1,N
      KPP_REAL X(N),Y(N)

      IF (N.LE.0) RETURN

      M = MOD(N,8)
      IF( M .NE. 0 ) THEN
        DO i = 1,M
          Y(i) = X(i)
        END DO
        IF( N .LT. 8 ) RETURN
      END IF
      MP1 = M+1
      DO i = MP1,N,8
        Y(i) = X(i)
        Y(i + 1) = X(i + 1)
        Y(i + 2) = X(i + 2)
        Y(i + 3) = X(i + 3)
        Y(i + 4) = X(i + 4)
        Y(i + 5) = X(i + 5)
        Y(i + 6) = X(i + 6)
        Y(i + 7) = X(i + 7)
      END DO
      RETURN
      END

! End of WCOPY

!--------------------------------------------------------------
      SUBROUTINE WAXPY(N,Alpha,X,incX,Y,incY)
!--------------------------------------------------------------
!     constant times a vector plus a vector: y <- y + Alpha*x
!     only for incX=incY=1
!     after BLAS
!     replace this by the function from the optimized BLAS implementation:
!         CALL SAXPY(N,Alpha,X,1,Y,1) or  CALL DAXPY(N,Alpha,X,1,Y,1)
!--------------------------------------------------------------

      INTEGER i,incX,incY,M,MP1,N
      KPP_REAL X(N),Y(N),Alpha
      KPP_REAL ZERO
      PARAMETER( ZERO = 0.0d0 )

      IF (Alpha .EQ. ZERO) RETURN
      IF (N .LE. 0) RETURN

      M = MOD(N,4)
      IF( M .NE. 0 ) THEN
        DO i = 1,M
          Y(i) = Y(i) + Alpha*X(i)
        END DO
        IF( N .LT. 4 ) RETURN
      END IF
      MP1 = M + 1
      DO i = MP1,N,4
        Y(i) = Y(i) + Alpha*X(i)
        Y(i + 1) = Y(i + 1) + Alpha*X(i + 1)
        Y(i + 2) = Y(i + 2) + Alpha*X(i + 2)
        Y(i + 3) = Y(i + 3) + Alpha*X(i + 3)
      END DO
      RETURN
      END

! End of WAXPY

!--------------------------------------------------------------
      SUBROUTINE WSCAL(N,Alpha,X,incX)
!--------------------------------------------------------------
!     constant times a vector: x(1:N) <- Alpha*x(1:N)
!     only for incX=incY=1
!     after BLAS
!     replace this by the function from the optimized BLAS implementation:
!         CALL SSCAL(N,Alpha,X,1) or  CALL DSCAL(N,Alpha,X,1)
!--------------------------------------------------------------

      INTEGER i,incX,M,MP1,N
      KPP_REAL X(N),Alpha
      KPP_REAL ZERO, ONE
      PARAMETER( ZERO = 0.0d0 )
      PARAMETER( ONE  = 1.0d0 )

      IF (Alpha .EQ. ONE) RETURN
      IF (N .LE. 0) RETURN

      M = MOD(N,5)
      IF( M .NE. 0 ) THEN
        IF (Alpha .EQ. (-ONE)) THEN
          DO i = 1,M
            X(i) = -X(i)
          END DO
        ELSEIF (Alpha .EQ. ZERO) THEN
          DO i = 1,M
            X(i) = ZERO
          END DO
        ELSE
          DO i = 1,M
            X(i) = Alpha*X(i)
          END DO
        END IF
        IF( N .LT. 5 ) RETURN
      END IF
      MP1 = M + 1
      IF (Alpha .EQ. (-ONE)) THEN
        DO i = MP1,N,5
          X(i)     = -X(i)
          X(i + 1) = -X(i + 1)
          X(i + 2) = -X(i + 2)
          X(i + 3) = -X(i + 3)
          X(i + 4) = -X(i + 4)
        END DO
      ELSEIF (Alpha .EQ. ZERO) THEN
        DO i = MP1,N,5
          X(i)     = ZERO
          X(i + 1) = ZERO
          X(i + 2) = ZERO
          X(i + 3) = ZERO
          X(i + 4) = ZERO
        END DO
      ELSE
        DO i = MP1,N,5
          X(i)     = Alpha*X(i)
          X(i + 1) = Alpha*X(i + 1)
          X(i + 2) = Alpha*X(i + 2)
          X(i + 3) = Alpha*X(i + 3)
          X(i + 4) = Alpha*X(i + 4)
        END DO
      END IF
      RETURN
      END

! End of WSCAL

!--------------------------------------------------------------
      KPP_REAL FUNCTION WLAMCH( C )
!--------------------------------------------------------------
!     returns epsilon machine
!     after LAPACK
!     replace this by the function from the optimized LAPACK implementation:
!          CALL SLAMCH('E') or CALL DLAMCH('E')
!--------------------------------------------------------------

      CHARACTER C
      INTEGER   i
      KPP_REAL  ONE, HALF, Eps, Suma
      PARAMETER (ONE  = 1.0d0)
      PARAMETER (HALF = 0.5d0)
      LOGICAL   First
      SAVE     First, Eps
      DATA     First /.TRUE./

      IF (First) THEN
        First = .FALSE.
        Eps = HALF**(16)
        DO i = 17, 80
          Eps = Eps*HALF
	  CALL WLAMCH_ADD(ONE,Eps,Suma)
	  IF (Suma.LE.ONE) GOTO 10
        END DO
        PRINT*,'ERROR IN WLAMCH. EPS < ',Eps
        RETURN
10      Eps = Eps*2
        i = i-1
      END IF

      WLAMCH = Eps

      RETURN
      END

      SUBROUTINE WLAMCH_ADD( A, B, Suma )
      KPP_REAL A, B, Suma
      Suma = A + B
      RETURN
      END

! End of WLAMCH

!--------------------------------------------------------------
      SUBROUTINE SET2ZERO(N,Y)
!--------------------------------------------------------------
!     copies zeros into the vector y:  y <- 0
!     after BLAS
!--------------------------------------------------------------

      INTEGER   i,M,MP1,N
      KPP_REAL  Y(N)

      IF (N.LE.0) RETURN

      M = MOD(N,8)
      IF( M .NE. 0 ) THEN
        DO i = 1,M
          Y(i) = 0.0d0
        END DO
        IF( N .LT. 8 ) RETURN
      END IF
      MP1 = M+1
      DO i = MP1,N,8
        Y(i)     = 0.0d0
        Y(i + 1) = 0.0d0
        Y(i + 2) = 0.0d0
        Y(i + 3) = 0.0d0
        Y(i + 4) = 0.0d0
        Y(i + 5) = 0.0d0
        Y(i + 6) = 0.0d0
        Y(i + 7) = 0.0d0
      END DO

      END SUBROUTINE SET2ZERO

! End of SET2ZERO

!--------------------------------------------------------------
      KPP_REAL FUNCTION WDOT (N, DX, incX, DY, incY)
!--------------------------------------------------------------
!     dot produce: wdot = x(1:N)*y(1:N)
!     only for incX=incY=1
!     after BLAS
!     replace this by the function from the optimized BLAS implementation:
!         CALL SDOT(N,X,1,Y,1) or  CALL DDOT(N,X,1,Y,1)
!--------------------------------------------------------------
!      USE messy_mecca_kpp_Precision
!--------------------------------------------------------------
      IMPLICIT NONE
      INTEGER  N, incX, incY
      KPP_REAL DX(N), DY(N)

      INTEGER  i, IX, IY, M, MP1, NS

      WDOT = 0.0D0
      IF (N .LE. 0) RETURN
      IF (incX .EQ. incY) IF (incX-1) 5,20,60
!
!     Code for unequal or nonpositive increments.
!
    5 IX = 1
      IY = 1
      IF (incX .LT. 0) IX = (-N+1)*incX + 1
      IF (incY .LT. 0) IY = (-N+1)*incY + 1
      DO i = 1,N
        WDOT = WDOT + DX(IX)*DY(IY)
        IX = IX + incX
        IY = IY + incY
      END DO
      RETURN
!
!     Code for both increments equal to 1.
!
!     Clean-up loop so remaining vector length is a multiple of 5.
!
   20 M = MOD(N,5)
      IF (M .EQ. 0) GO TO 40
      DO i = 1,M
         WDOT = WDOT + DX(i)*DY(i)
      END DO
      IF (N .LT. 5) RETURN
   40 MP1 = M + 1
      DO i = MP1,N,5
          WDOT = WDOT + DX(i)*DY(i)
     &            + DX(i+1)*DY(i+1) + DX(i+2)*DY(i+2)
     &            + DX(i+3)*DY(i+3) + DX(i+4)*DY(i+4)
      END DO
      RETURN
!
!     Code for equal, positive, non-unit increments.
!
   60 NS = N*incX
      DO i = 1,NS,incX
        WDOT = WDOT + DX(i)*DY(i)
      END DO

      END FUNCTION WDOT

! End of WDOT

!--------------------------------------------------------------
      SUBROUTINE WADD(N,X,Y,Z)
!--------------------------------------------------------------
!     adds two vectors: z <- x + y
!     BLAS - like
!--------------------------------------------------------------

      INTEGER  i, M, MP1, N
      KPP_REAL  X(N),Y(N),Z(N)

      IF (N.LE.0) RETURN

      M = MOD(N,5)
      IF( M .NE. 0 ) THEN
         DO i = 1,M
            Z(i) = X(i) + Y(i)
         END DO
         IF( N .LT. 5 ) RETURN
      END IF
      MP1 = M+1
      DO i = MP1,N,5
         Z(i)     = X(i)     + Y(i)
         Z(i + 1) = X(i + 1) + Y(i + 1)
         Z(i + 2) = X(i + 2) + Y(i + 2)
         Z(i + 3) = X(i + 3) + Y(i + 3)
         Z(i + 4) = X(i + 4) + Y(i + 4)
      END DO

      END SUBROUTINE WADD

! End of WADD
!--------------------------------------------------------------
