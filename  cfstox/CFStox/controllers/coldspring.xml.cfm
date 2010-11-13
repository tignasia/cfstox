<!DOCTYPE beans PUBLIC "-//SPRING//DTD BEAN//EN" "http://www.springframework.org/dtd/spring-beans.dtd">
<beans default-autowire="byName">
	<bean id="Chart" 		class="cfstox.model.Chart" />
	<bean id="DataService" 	class="cfstox.model.DataService" />
	<bean id="http" 		class="cfstox.model.http" />
</beans>